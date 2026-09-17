-- Navigate to the herdr agent pane.
--
-- herdr owns the agent process, and the agent lives in its own pane. This
-- module only moves focus there. Going back is herdr's own `last_pane` chord
-- (ctrl+cmd+y, see herdr/config.toml). herdr grabs that chord globally, so it
-- fires from inside the agent pane, where no nvim keymap can reach.

local M = {}

---Focus history written by the herdr-mru plugin (herdr/mru/track.sh).
---One line per focus: "<ms> <workspace_id> <pane_id> <walk marker>".
local function mru_log()
	local dir = vim.env.HERDR_MRU_DIR
	if not dir then
		local state = vim.env.XDG_STATE_HOME or vim.fs.joinpath(vim.env.HOME, ".local", "state")
		dir = vim.fs.joinpath(state, "herdr-mru")
	end
	return vim.fs.joinpath(dir, "focus.log")
end

---@param args string[]
---@return string? stdout, string? err
local function herdr(args)
	local cmd = { "herdr" }
	vim.list_extend(cmd, args)
	local res = vim.system(cmd, { text = true }):wait()
	if res.code ~= 0 then
		local msg = vim.trim(res.stderr ~= "" and res.stderr or res.stdout)
		return nil, msg ~= "" and msg or ("herdr exited " .. res.code)
	end
	return res.stdout
end

---How recently each pane held focus. Lower is more recent; a pane absent from
---the history is not in the table. Reads the log backwards, so the first time
---a pane appears is its latest visit.
---@return table<string, integer>
local function recency()
	local path = mru_log()
	if vim.fn.filereadable(path) ~= 1 then
		return {}
	end

	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return {}
	end

	local rank, seen = {}, 0
	for i = #lines, 1, -1 do
		local pane = lines[i]:match("^%d+%s+%S+%s+(%S+)")
		if pane and pane ~= "-" and not rank[pane] then
			seen = seen + 1
			rank[pane] = seen
		end
	end
	return rank
end

---Live agents, nearest first. Our own pane is never a candidate, so an agent
---hosting nvim cannot select itself.
---
---Order is proximity, then recency. Proximity comes first because an agent in
---this tab is almost always the one you mean. Recency breaks the tie, which is
---what decides it once a tab holds more than one agent; without it the winner
---is whatever `herdr agent list` happened to print first.
---@return table[]? agents, string? err
function M.agents()
	local out, err = herdr({ "agent", "list" })
	if not out then
		return nil, err
	end
	local ok, decoded = pcall(vim.json.decode, out)
	if not ok then
		return nil, "could not read `herdr agent list`"
	end

	local me = vim.env.HERDR_PANE_ID
	local rank = recency()
	local candidates = {}
	for _, agent in ipairs(vim.tbl_get(decoded, "result", "agents") or {}) do
		if agent.pane_id ~= me then
			local proximity
			if agent.tab_id == vim.env.HERDR_TAB_ID then
				proximity = 1
			elseif agent.workspace_id == vim.env.HERDR_WORKSPACE_ID then
				proximity = 2
			end
			if proximity then
				table.insert(candidates, {
					agent = agent,
					proximity = proximity,
					recency = rank[agent.pane_id] or math.huge,
					order = #candidates,
				})
			end
		end
	end

	-- `order` keeps the sort stable: two agents herdr never saw you focus stay
	-- in the order herdr listed them, rather than swapping between presses.
	table.sort(candidates, function(a, b)
		if a.proximity ~= b.proximity then
			return a.proximity < b.proximity
		end
		if a.recency ~= b.recency then
			return a.recency < b.recency
		end
		return a.order < b.order
	end)

	return vim.tbl_map(function(c)
		return c.agent
	end, candidates)
end

-- Below this width (columns) our pane splits down instead of right, so that
-- neither half falls under a readable ~80 columns.
local MIN_SPLIT_WIDTH = 160

---Which way to split our own pane. herdr knows the real geometry; `vim.o.columns`
---does not, because it cannot see the sidebar or the other panes.
---@return "right"|"down"
local function split_direction()
	local out = herdr({ "pane", "layout", "--current" })
	if not out then
		return "right"
	end
	local ok, decoded = pcall(vim.json.decode, out)
	if not ok then
		return "right"
	end

	for _, pane in ipairs(vim.tbl_get(decoded, "result", "layout", "panes") or {}) do
		if pane.pane_id == vim.env.HERDR_PANE_ID then
			return pane.rect.width >= MIN_SPLIT_WIDTH and "right" or "down"
		end
	end
	return "right"
end

---A herdr agent name for this project: the git root's basename, cut to what
---herdr accepts (`[a-z][a-z0-9_-]{0,31}`).
---@return string?
local function agent_name()
	local root = vim.fs.root(0, ".git")
	if not root then
		return nil
	end
	local name = vim.fs.basename(root):lower():gsub("[^a-z0-9_-]", "-"):sub(1, 32)
	return name:match("^[a-z]") and name or nil
end

---Name the agent once herdr has detected it. Detection takes a moment, so this
---retries in the background rather than blocking the editor.
---
---The name is a convenience, not a requirement: it makes the herdr sidebar and
---the MRU pickers readable, and it lets `herdr agent focus <name>` work from a
---script. Focus here uses pane ids, so a failure costs nothing and stays quiet.
---A name already taken by a live agent is the usual reason, for instance a
---second worktree of the same repo.
---@param pane_id string
---@param name string
---@param tries integer
local function name_agent(pane_id, name, tries)
	if tries <= 0 then
		return
	end
	vim.system({ "herdr", "agent", "rename", pane_id, name }, { text = true }, function(res)
		if res.code ~= 0 then
			vim.defer_fn(function()
				name_agent(pane_id, name, tries - 1)
			end, 700)
		end
	end)
end

---Split our pane and start the agent in it. herdr owns the process, so it
---survives quitting nvim, and herdr can track its state.
---@return boolean started
function M.start()
	local cwd = vim.fs.root(0, ".git") or vim.uv.cwd()

	local out, err = herdr({
		"pane",
		"split",
		"--current",
		"--direction",
		split_direction(),
		"--cwd",
		cwd,
		"--focus",
	})
	if not out then
		vim.notify("herdr: could not split the pane: " .. err, vim.log.levels.ERROR)
		return false
	end

	local ok, decoded = pcall(vim.json.decode, out)
	local pane_id = ok and vim.tbl_get(decoded, "result", "pane", "pane_id")
	if not pane_id then
		vim.notify("herdr: split gave no pane id", vim.log.levels.ERROR)
		return false
	end

	-- `exec` replaces the pane's shell, so the pane closes when the agent exits.
	-- We run `cld`, not `herdr agent start --kind claude`: that starts the
	-- canonical `claude` and so skips the wrapper in ai/cmds/cld, which unsets
	-- the ANTHROPIC_* overrides and adds `--permission-mode auto` over SSH.
	local _, run_err = herdr({ "pane", "run", pane_id, "exec cld" })
	if run_err then
		vim.notify("herdr: could not start the agent: " .. run_err, vim.log.levels.ERROR)
		return false
	end

	local name = agent_name()
	if name then
		name_agent(pane_id, name, 10)
	end
	return true
end

---Move focus to the nearest agent, starting one if this workspace has none.
function M.focus()
	if vim.env.HERDR_PANE_ID == nil then
		vim.notify("herdr: nvim is not running in a herdr pane", vim.log.levels.WARN)
		return
	end

	local agents, err = M.agents()
	if not agents then
		vim.notify("herdr: " .. err, vim.log.levels.ERROR)
		return
	end
	if #agents == 0 then
		M.start()
		return
	end

	local _, focus_err = herdr({ "agent", "focus", agents[1].pane_id })
	if focus_err then
		vim.notify("herdr: " .. focus_err, vim.log.levels.ERROR)
	end
end

---Where the cursor or the selection sits, as `@path L3` or `@path L3-L9`.
---The path is relative to the agent's cwd. This is sidekick's `{file}` and
---`{position}` shape, so the muscle memory carries over.
---@param from integer? first line, 1-based
---@param to integer? last line, 1-based
---@return string
local function location(from, to)
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return "[No Name]"
	end

	local ok, rel = pcall(vim.fs.relpath, vim.uv.cwd(), name)
	local loc = "@" .. ((ok and rel and rel ~= "") and rel or name)
	if not from then
		return loc
	end
	return to and to ~= from and ("%s L%d-L%d"):format(loc, from, to) or ("%s L%d"):format(loc, from)
end

---Put the current file, or the visual selection, in the agent's prompt.
---
---It stages the text and stops. `herdr pane send-text` writes the text without
---Enter, so you read it and submit it yourself. Compare `herdr agent prompt`,
---which submits, and `herdr pane run`, which appends Enter.
---@param opts? { selection?: boolean }
function M.send(opts)
	opts = opts or {}

	local agents, err = M.agents()
	if not agents then
		vim.notify("herdr: " .. err, vim.log.levels.ERROR)
		return
	end
	if #agents == 0 then
		vim.notify("herdr: no agent to send to", vim.log.levels.WARN)
		return
	end

	local text
	if opts.selection then
		-- getpos() is only correct once visual mode has ended.
		vim.cmd("normal! \27")
		local from, to = vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2]
		local lines = vim.api.nvim_buf_get_lines(0, from - 1, to, false)
		text = ("%s\n\n```%s\n%s\n```\n"):format(location(from, to), vim.bo.filetype, table.concat(lines, "\n"))
	else
		text = location(vim.api.nvim_win_get_cursor(0)[1]) .. " "
	end

	local pane_id = agents[1].pane_id
	local _, send_err = herdr({ "pane", "send-text", pane_id, text })
	if send_err then
		vim.notify("herdr: " .. send_err, vim.log.levels.ERROR)
		return
	end

	-- Follow the text. Staging leaves the prompt unsent, so you have to be there
	-- to read it and press Enter. Focus after the send, never before, or you
	-- arrive at an empty prompt and watch it fill.
	local _, focus_err = herdr({ "agent", "focus", pane_id })
	if focus_err then
		vim.notify("herdr: " .. focus_err, vim.log.levels.ERROR)
	end
end

return M
