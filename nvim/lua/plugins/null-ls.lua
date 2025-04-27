return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- JavaScript
				null_ls.builtins.formatting.prettier,

				-- Other
				null_ls.builtins.completion.spell,
				-- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
			},
		})
		end,
}
