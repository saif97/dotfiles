return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			---@class snacks.picker.matcher.Config
			matcher = {
				fuzzy = true,      -- use fuzzy matching
				smartcase = true,  -- use smartcase
				ignorecase = true, -- use ignorecase
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true,   -- support patterns like `file:line:col` and `file:line`
				-- the bonusses below, possibly require string concatenation and path normalization,
				-- so this can have a performance impact for large lists and increase memory usage
				cwd_bonus = false, -- give bonus for matching files in the cwd
				frecency = true,  -- frecency bonus
				history_bonus = true, -- give more weight to chronological order
			},
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
}
