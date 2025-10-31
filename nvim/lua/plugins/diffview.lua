require("utils")

return {
	"sindrets/diffview.nvim",

	config = function()
		-- Lua
		local actions = require("diffview.actions")
		map_key("n", "<leader>of", "<Cmd>DiffviewOpen<CR>", { desc = "Open diFfview" })

		require("diffview").setup({
			enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
			hooks = {
				-- Disable auto-resizing for diffview windows
				diff_buf_win_enter = function(bufnr, winid, ctx)
					vim.wo[winid].winfixwidth = true
					vim.wo[winid].winfixheight = true
				end,
			},
			keymaps = {
				view = {
					{ "n", "-", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
				},
				file_panel = {
					{ "n", "E",      actions.select_next_entry, { desc = "Bring the cursor to the next file entry" } },
					{ "n", "e",      actions.next_entry,        { desc = "Bring the cursor to the next file entry" } },
					{ "n", "<down>", actions.next_entry,        { desc = "Bring the cursor to the next file entry" } },
					{ "n", "U",      actions.select_prev_entry, { desc = "Bring the cursor to the previous file entry" } },
					{ "n", "<up>",   actions.prev_entry,        { desc = "Bring the cursor to the previous file entry" } },
					{ "n", "i",      actions.prev_entry,        { desc = "Open the diff for the selected entry" } },
				},
			},
		})
	end
}
