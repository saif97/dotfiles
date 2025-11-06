vim.api.nvim_create_user_command("Gitsigns blame", "Gitsigns blame", { desc = "Show git blame for the current line" })

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		map_key("n", "gs", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Git Stage hunk" })
		map_key({"n", "v"}, "gR", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "Git Reset hunk" })
		map_key("n", "gP", "<Cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git Preview hunk" })
		map_key("n", "gB", "<Cmd>Gitsigns blame_line<CR>", { desc = "Git Blame line" })

		map_key("n", "]c", ":Gitsigns nav_hunk next<CR>", { desc = "Git next hunk" })
		map_key("n", "[c", ":Gitsigns nav_hunk prev<CR>", { desc = "Git prev hunk" })
		require("gitsigns").setup({
			current_line_blame = true,
			preview_config = {
				border = "rounded",
			},
		})
	end,
}
