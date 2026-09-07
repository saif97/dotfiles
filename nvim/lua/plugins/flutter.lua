return {
	'nvim-flutter/flutter-tools.nvim',
	commit = "65b7399804315a1160933b64292d3c5330aa4e9f",
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
