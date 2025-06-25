-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		
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
		require("mason-lspconfig").setup({
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
