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
	{ "tpope/vim-abolish" },
	{
		'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter'}, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	}
}
