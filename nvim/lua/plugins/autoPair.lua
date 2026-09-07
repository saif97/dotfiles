return {
	"windwp/nvim-autopairs",
	commit = "4d74e75913832866aa7de35e4202463ddf6efd1b",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			-- Disable the default <CR> mapping so we can handle it ourselves
			map_cr = false,
		})
	end,
}
