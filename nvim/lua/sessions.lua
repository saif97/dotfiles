-- One session per working directory: saved on exit, restored on a bare `nvim`.
local M = {}

local session_dir = vim.fn.stdpath("state") .. "/sessions/"

local skipped_dirs = {}
for _, dir in ipairs({ "~", "~/Projects", "~/Downloads", "/" }) do
	skipped_dirs[vim.fn.expand(dir)] = true
end

-- Only a bare `nvim` owns the session. `nvim file`, `git commit` and pagers do not.
local enabled = false

local function session_file(cwd)
	return session_dir .. cwd:gsub("/", "%%") .. ".vim"
end

local function save()
	local cwd = vim.fn.getcwd()
	if not enabled or skipped_dirs[cwd] then return end
	pcall(vim.cmd, "Neotree close")
	vim.fn.mkdir(session_dir, "p")
	vim.cmd("mksession! " .. vim.fn.fnameescape(session_file(cwd)))
end

function M.setup()
	vim.opt.sessionoptions:remove({ "blank", "help", "terminal" })

	local group = vim.api.nvim_create_augroup("sessions", { clear = true })

	vim.api.nvim_create_autocmd("StdinReadPre", {
		group = group,
		callback = function() vim.g.in_pager_mode = true end,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		desc = "Restore the session of the working directory",
		group = group,
		nested = true,
		callback = function()
			if vim.fn.argc() > 0 or vim.g.in_pager_mode then return end
			enabled = true
			local file = session_file(vim.fn.getcwd())
			if vim.fn.filereadable(file) == 1 then
				vim.cmd("silent! source " .. vim.fn.fnameescape(file))
			end
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		desc = "Save the session of the working directory",
		group = group,
		callback = save,
	})
end

return M
