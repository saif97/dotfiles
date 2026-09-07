-- lazy.nvim
return {
	"chrisgrieser/nvim-justice",
	commit = "f193f243fe4cb6878293cf85c099524287ee917d",

	config = function()
		-- default settings
		require("justice").setup {
		}
	end
}
