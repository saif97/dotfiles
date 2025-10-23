return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			-- Disable the default <CR> mapping so we can handle it ourselves
			map_cr = false,
		})
	end,
}
