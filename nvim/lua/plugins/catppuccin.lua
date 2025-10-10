return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			transparent_background = isPersonalMachine(),
			term_colors = true,
		})

		vim.cmd.colorscheme("catppuccin")
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#6e738d" })

		vim.api.nvim_set_hl(0, "LineNr", { fg = "#a5adcb" })
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#a5adcb" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#eed49f" })
	end,
}
