-- Good read on super tab https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip

return {
	"L3MON4D3/LuaSnip",
	commit = "458560534a73f7f8d7a11a146c801db00b081df0",
	dependencies = { "rafamadriz/friendly-snippets" },
	-- follow latest release. (the pinned commit above IS tag v2.4.0)
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	-- build = "make install_jsregexp",
	--
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
		require("config.snippets.mySnippets").setup()
	end,
}
