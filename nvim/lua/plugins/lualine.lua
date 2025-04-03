return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local custom_gruvbox = require("lualine.themes.catppuccin")
		custom_gruvbox.inactive.a.bg = "#e78284"
		custom_gruvbox.inactive.a.fg = "#181926"

		require("lualine").setup({
			options = { theme = custom_gruvbox },

			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = { "location" },
			},
		})
	end,
}
