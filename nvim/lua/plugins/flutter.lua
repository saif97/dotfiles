return {
	'nvim-flutter/flutter-tools.nvim',
	lazy = false,
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function()
		-- flutter_path omitted on purpose — flutter-tools auto-discovers via $PATH.
		require('flutter-tools').setup({
			-- fvm = true,
			widget_guides = {
				enabled = true,
			},
		})
	end,
}
