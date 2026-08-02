local M = {}

local window_sizing = {
	focused_width = 120,
	focused_height = 999,
	normal_min_width = 20,
	normal_min_height = 2,
	neutral_min_width = 1,
	neutral_min_height = 1,
}

local function use_neutral_window_sizing()
	vim.o.winminwidth = window_sizing.neutral_min_width
	vim.o.winwidth = window_sizing.neutral_min_width
	vim.o.winminheight = window_sizing.neutral_min_height
	vim.o.winheight = window_sizing.neutral_min_height
end

local function use_normal_window_sizing()
	vim.o.winwidth = window_sizing.normal_min_width
	vim.o.winminwidth = window_sizing.normal_min_width
	vim.o.winheight = window_sizing.normal_min_height
	vim.o.winminheight = window_sizing.normal_min_height
end

local function is_diff_layout()
	local has_diff_layout = false
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		local filetype = vim.bo[buf].filetype
		local name = vim.api.nvim_buf_get_name(buf)
		if vim.wo[win].diff or filetype:match("^Diffview") or name:match("^diffview://") then
			has_diff_layout = true
			break
		end
	end
	return has_diff_layout
end

local function is_editor_window(win)
	if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_config(win).relative ~= "" then
		return false
	end

	local buf = vim.api.nvim_win_get_buf(win)
	local name = vim.api.nvim_buf_get_name(buf)
	return vim.bo[buf].buftype == "" and not name:match("^%w[%w+.-]*://")
end

local function resize_focused_editor()
	if is_diff_layout() then
		use_neutral_window_sizing()
		return
	end

	local win = vim.api.nvim_get_current_win()
	if not is_editor_window(win) then
		use_neutral_window_sizing()
		return
	end

	use_normal_window_sizing()
	vim.api.nvim_win_set_width(win, window_sizing.focused_width)
	vim.api.nvim_win_set_height(win, window_sizing.focused_height)
end

local resize_pending = false
local function schedule_window_resize()
	if resize_pending then return end
	resize_pending = true
	vim.schedule(function()
		resize_pending = false
		local ok, err = xpcall(resize_focused_editor, debug.traceback)
		if ok then return end

		local restored, restore_err = pcall(use_neutral_window_sizing)
		local message = "Window sizing failed:\n" .. err
		if not restored then
			message = message .. "\nFailed to restore neutral sizing: " .. restore_err
		end
		vim.notify(message, vim.log.levels.ERROR, { title = "Window sizing" })
	end)
end

function M.setup()
	use_neutral_window_sizing()
	local group = vim.api.nvim_create_augroup("contextual-window-sizing", { clear = true })
	vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "WinClosed", "BufWinEnter", "TabEnter", "VimResized" }, {
		desc = "Enlarge focused editor windows without affecting plugin layouts",
		group = group,
		callback = schedule_window_resize,
	})
	vim.api.nvim_create_autocmd("WinLeave", {
		desc = "Neutralize window sizing before entering another layout",
		group = group,
		callback = use_neutral_window_sizing,
	})
	vim.api.nvim_create_autocmd("OptionSet", {
		desc = "Update window sizing when diff mode changes",
		group = group,
		pattern = "diff",
		callback = schedule_window_resize,
	})
end

return M
