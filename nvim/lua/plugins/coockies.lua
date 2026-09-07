return {
	--[[

		cr = ChaR	
		crs -> snake_case
		crm -> MixedCase
		crc -> camelCase
		cru -> UPPER_CASE
		cr- -> dash-case
		cr. -> dot.case
	]]
	{ "tpope/vim-abolish", commit = "dcbfe065297d31823561ba787f51056c147aa682" },
	{
		'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
		commit = "be69bff86754b1aa5adcbb527d7fcd1635a84080",
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		commit = "6e0e8902dac70fecbdd8ce557d142062a621ec38",
		dependencies = { 'nvim-treesitter/nvim-treesitter'}, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	}
}
