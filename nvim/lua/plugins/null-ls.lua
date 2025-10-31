return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- JavaScript
				null_ls.builtins.formatting.prettier,

				-- Shell/Bash
				null_ls.builtins.formatting.shfmt,

				-- Other
				null_ls.builtins.completion.spell,
				-- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
			},
		})
		end,
}
