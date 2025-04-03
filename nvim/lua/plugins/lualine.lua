return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local custom_gruvbox = require("lualine.themes.catppuccin")
		custom_gruvbox.inactive.a.bg = "#8bd5ca"
		custom_gruvbox.inactive.a.fg = "#181926"

		require("lualine").setup({
			options = {
				theme = custom_gruvbox,

				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			},
		})
	end,
}
