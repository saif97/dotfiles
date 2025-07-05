-- Consolidated LSP configuration
-- Combines mason.nvim, mason-lspconfig.nvim, and nvim-lspconfig setup

local servers = {
	"lua_ls",
	"pyright",
	"ruff",
	"ts_ls",
	"html",
	"cssls",
	"jsonls",
}

local personal_servers = {
	"solidity",
}

if os.getenv("IS_PERSONAL_MACHINE") then
	vim.list_extend(servers, personal_servers)
end

return {
	{
		"williamboman/mason.nvim",
		---@class MasonSettings
		opts = {
			ui = {
				keymaps = {
					install_package = "<D-i>",
					update_package = "<D-u>",
					update_all_packages = "<D-p>",
					check_package_version = "v",
				},
			},
		},
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			-- LSP capabilities for completion
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Setup mason-lspconfig
			require("mason-lspconfig").setup({
				automatic_installation = false,
			})

			-- Enable LSP servers using Neovim 0.11+ API
			vim.lsp.enable(servers)

			-- Diagnostic configuration
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		---@class MasonLspConfigSettings
		opts = {
			ensure_installed = servers,
			automatic_installation = true,
		},
	},
}
