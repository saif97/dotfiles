-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		
		-- Diagnostic Config
		-- See :help vim.diagnostic.Opts
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
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

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers = {
			-- clangd = {},
			-- gopls = {},
			-- rust_analyzer = {},
			-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
			--
			-- Some languages (like typescript) have entire language plugins that can be useful:
			--    https://github.com/pmizio/typescript-tools.nvim
			--
			-- But for many setups, the LSP (`ts_ls`) will work just fine
			-- Python Land

			-- solidity_ls = {
			-- 	cmd = { "vscode-solidity-server", "--stdio" },
			-- 	filetypes = { "solidity" },
			-- 	root_dir = lspconfig.util.root_pattern("hardhat.config.js", "foundry.toml", ".git"),
			-- 	settings = {
			-- 		solidity = {
			-- 			compileUsingRemoteVersion = "latest",
			-- 			defaultCompiler = "remote",
			-- 			enabledAsYouTypeCompilationErrorCheck = true,
			-- 		},
			-- 	},
			-- },

			-- ruff = {
			-- 	init_options = {
			-- 		settings = {
			-- 			lineLength = 100,
			-- 		},
			-- 	},
			-- },
		}

		-- Ensure the servers and tools above are installed
		--
		-- To check the current status of installed tools and/or manually install
		-- other tools, you can run
		--    :Mason
		--
		-- You can press `g?` for help in this menu.
		--
		-- `mason` had to be setup earlier: to configure its options see the
		-- `dependencies` table for `nvim-lspconfig` above.
		--
		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			-- lua
			"stylua", -- Used to format Lua code
			"lua-language-server",
			-- bash
			"bash-language-server",
			"shellcheck",
			-- python
			-- "ruff",
			"pyright",
			-- JS/TS
			"typescript-language-server",
		})
		if os.getenv("IS_PERSONAL_MACHINE") then
			local lspconfig = require("lspconfig")
			local configs = require("lspconfig.configs")

			configs.solidity = {
				default_config = {
					cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
					filetypes = { "solidity" },
					root_dir = lspconfig.util.find_git_ancestor,
					single_file_support = true,
				},
			}

			lspconfig.solidity.setup({})
		end
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for ts_ls)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
