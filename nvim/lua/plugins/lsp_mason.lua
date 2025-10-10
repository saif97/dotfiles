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
	"bashls",
	"dockerls",
}

local personal_servers = {
	"solidity",
	"copilot",
}

if os.getenv("IS_PERSONAL_MACHINE") then
	vim.list_extend(servers, personal_servers)
end

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
	"bashls",
	"dockerls",
}

local personal_servers = {
	"solidity",
	"copilot",
}

if os.getenv("IS_PERSONAL_MACHINE") then
	vim.list_extend(servers, personal_servers)
end

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					keymaps = {
						install_package = "<D-i>",
						update_package = "<D-u>",
						update_all_packages = "<D-p>",
						check_package_version = "v",
					},
				},
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = servers,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
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
}
