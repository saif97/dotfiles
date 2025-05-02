-- Good read on super tab https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip

return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	-- build = "make install_jsregexp",
	--
	config = function()
		require("config.snippets.mySnippets").setup()
	end,
}
