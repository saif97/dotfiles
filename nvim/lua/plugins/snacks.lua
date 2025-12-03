return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		indent = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
			style = "compact",
		},
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
			win = {
				-- input window
				input = {
					keys = {
						-- to close the picker on ESC instead of going to normal mode,
						-- add the following keymap to your config
						["<Esc>"] = { "close", mode = { "n", "i" } },
						["<D-e>"] = { "history_forward", mode = { "i", "n" } },
						["<D-u>"] = { "history_back", mode = { "i", "n" } },
						["<D-f>"] = { "toggle_follow", mode = { "i", "n" } },
						["<D-M>"] = { "toggle_hidden", mode = { "i", "n" } },
						["<D-i>"] = { "toggle_ignored", mode = { "i", "n" } },
						["<D-m>"] = { "toggle_maximize", mode = { "i", "n" } },
						["<D-p>"] = { "toggle_preview", mode = { "i", "n" } },
					},
					b = {
						minipairs_disable = true,
					},
				},
				preview = {
					keys = {
						["i"] = false,
						["<Esc>"] = "focus_input",
					},
				},

				-- result list window
				list = {
					keys = {
						["<D-f>"] = "toggle_follow",
						["<D-d>"] = "toggle_hidden",
						["<D-i>"] = "toggle_ignored",
						["<D-m>"] = "toggle_maximize",
						["<D-p>"] = "toggle_preview",
					},
				},
			},
		},
	},
}
