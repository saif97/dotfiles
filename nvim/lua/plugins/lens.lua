return {
	"camspiers/lens.vim",
		config = function()
      -- Set the maximum height for the focused window to a large value
      vim.g['lens#height_resize_max'] = vim.o.lines - 2

      -- Set the maximum width for the focused window to a large value
      vim.g['lens#width_resize_max'] = vim.o.columns - 2
   end
}
