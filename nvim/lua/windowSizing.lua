local M = {}

local sizing = {
	focused_width = 120,
	focused_height = 999,
	min_width = 20,
	min_height = 2,
}

local function use_normal_sizing()
	vim.o.winwidth = sizing.focused_width
	vim.o.winheight = sizing.focused_height
	vim.o.winminwidth = sizing.min_width
	vim.o.winminheight = sizing.min_height
end

local function use_neutral_sizing()
	vim.o.winminwidth = 1
	vim.o.winminheight = 1
	vim.o.winwidth = 1
	vim.o.winheight = 1
end

local function is_diffview_tab()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		local filetype = vim.bo[buf].filetype
		local name = vim.api.nvim_buf_get_name(buf)
		if filetype:match("^Diffview") or name:match("^diffview://") then
			return true
		end
	end
	return false
end

local update_pending = false
local function schedule_sizing_update()
	if update_pending then return end
	update_pending = true
	vim.schedule(function()
		update_pending = false
		if is_diffview_tab() then
			use_neutral_sizing()
		else
			use_normal_sizing()
		end
	end)
end

function M.setup()
	use_normal_sizing()

	local group = vim.api.nvim_create_augroup("contextual-window-sizing", { clear = true })

	-- A tab switch enters its first window before TabEnter fires. Neutralize the
	-- global sizing first so a Diffview tab is never reshaped during that switch.
	vim.api.nvim_create_autocmd({ "TabLeave", "TabNew" }, {
		desc = "Neutralize sizing while a tab layout is being entered",
		group = group,
		callback = use_neutral_sizing,
	})

	vim.api.nvim_create_autocmd({ "VimEnter", "TabEnter" }, {
		desc = "Use native focused-window sizing outside Diffview tabs",
		group = group,
		callback = schedule_sizing_update,
	})

	vim.api.nvim_create_autocmd("User", {
		desc = "Keep Diffview layouts balanced",
		group = group,
		pattern = { "DiffviewViewOpened", "DiffviewViewEnter", "DiffviewViewPostLayout" },
		callback = use_neutral_sizing,
	})

	vim.api.nvim_create_autocmd("User", {
		desc = "Restore focused-window sizing after leaving Diffview",
		group = group,
		pattern = { "DiffviewViewClosed", "DiffviewViewLeave" },
		callback = schedule_sizing_update,
	})
end

return M
