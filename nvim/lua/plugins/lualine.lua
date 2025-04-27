return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local custom_gruvbox = require("lualine.themes.catppuccin")
		custom_gruvbox.inactive.a.bg = "#8bd5ca"
		custom_gruvbox.inactive.a.fg = "#181926"
		custom_gruvbox.inactive.c.bg = "#292c3c"

		require("lualine").setup({
			options = {
				theme = custom_gruvbox,
				globalstatus = false,
			},
			sections = {
				lualine_a = {
					function()
						return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
					end,
				},
				lualine_b = {
					{
						"filename",
						path = 0, -- 0: Just the filename
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
						shorting_target = 40, -- leavse 40 chars in the window so left & right don't overlap
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "branch", "diff", "diagnostics" },
				lualine_z = {
					"mode",
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						color = { fg = "#f2cdcd" }, -- Set the text color (fg) and background color (bg)
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},

			-- inactive_winbar = {
			-- 	lualine_a = { { "filename", color = { fg = "#232634" } } }, -- customize font and background color
			-- 	lualine_b = {},
			-- 	lualine_c = {},
			-- 	lualine_x = {},
			-- 	lualine_y = {},
			-- 	lualine_z = {},
			-- },
		})
	end,
}
