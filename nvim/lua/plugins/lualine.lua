return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local custom_gruvbox = require("lualine.themes.catppuccin")
		custom_gruvbox.inactive.a.bg = "#8bd5ca"
		custom_gruvbox.inactive.a.fg = "#181926"
		custom_gruvbox.inactive.c.fg = "#303446"
		custom_gruvbox.inactive.c.bg = "#babbf1"

		-- Check if SANDBOX or SSH environment variables are set
		local function is_sandbox_or_ssh()
			local sandbox = vim.env.SANDBOX
			local ssh = vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT or vim.env.SSH_TTY
			return sandbox or ssh
		end

		-- Custom component for sandbox/SSH indicator
		local function sandbox_indicator()
			if vim.env.SANDBOX then
				return "🔒 SANDBOX"
			elseif vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT or vim.env.SSH_TTY then
				return "🔐 SSH"
			end
			return ""
		end

		require("lualine").setup({
			options = {
				theme = custom_gruvbox,
				globalstatus = false,
			},
			sections = {
				lualine_a = {
					{
						sandbox_indicator,
						color = function()
							if is_sandbox_or_ssh() then
								return { fg = "#ffffff", bg = "#f38ba8", gui = "bold" }
							end
							return {}
						end,
					},
					{
						function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						end,
					},
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
					{
						"mode",
						fmt = function (str)
							return str:sub(1,1)
						end
					},
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						color = function()
							if is_sandbox_or_ssh() then
								return { fg = "#181926", bg = "#e78284" }
							end
							return { fg = "#303446" }
						end,
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
