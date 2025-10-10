return {
	'nvim-flutter/flutter-tools.nvim',
	lazy = false,
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function()
		local flutterPath = isPersonalMachine() and "$HOME/fvm/versions/stable/bin/flutter" or nil;

		require('flutter-tools').setup({
			-- fvm = true,
			flutter_path = flutterPath,
			widget_guides = {
				enabled = true,
			},
		})
	end,
}
