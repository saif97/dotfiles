return {
	'nvim-flutter/flutter-tools.nvim',
	lazy = false,
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function()
		require('flutter-tools').setup({
			-- fvm = true,
			flutter_path = "$HOME/fvm/versions/stable/bin/flutter",
		})
	end,
}
