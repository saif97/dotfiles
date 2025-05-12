-- Good read on super tab https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip

return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	-- build = "make install_jsregexp",
	--
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
		require("config.snippets.mySnippets").setup()
	end,
}
