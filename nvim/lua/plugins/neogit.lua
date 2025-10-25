require("utils")

return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",  -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed.
		-- "nvim-telescope/telescope.nvim", -- optional
		-- "ibhagwan/fzf-lua",              -- optional
		-- "echasnovski/mini.pick",         -- optional
		-- "folke/snacks.nvim",             -- optional
	},

	config = function()
		local neogit = require("neogit")
		map_key({ "n" }, "<leader>og", neogit.open, { desc = "Open neoGit" })

		neogit.setup {
			-- "ascii"   is the graph the git CLI generates
			-- "unicode" is the graph like https://github.com/rbong/vim-flog
			-- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
			graph_style = "kitty",
			-- Set to false if you want to be responsible for creating _ALL_ keymappings
			use_default_keymaps = true,
			commit_editor = {
				-- Accepted values:
				-- "split" to show the staged diff below the commit editor
				-- "vsplit" to show it to the right
				-- "split_above" Like :top split
				-- "vsplit_left" like :vsplit, but open to the left
				-- "auto" "vsplit" if window would have 80 cols, otherwise "split"
				staged_diff_split_kind = "vsplit",
			},
			-- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
			integrations = {
				telescope = false,
				-- Requires you to have `sindrets/diffview.nvim` installed.
				diffview = true,
				-- Requires you to have `folke/snacks.nvim` installed.
				snacks = true,
			},
			-- Custom Colemak-inspired keybindings (overrides defaults)
			mappings = {
				commit_editor = {
					["<c-CR>"] = "Submit",
					["q"] = "Abort",
				},
				status = {
					["e"] = "MoveDown",  -- Colemak: e instead of j
					["u"] = "MoveUp",    -- Colemak: u instead of k
					["i"] = "Toggle",    -- Colemak: i for toggle
					["n"] = "Toggle",    -- Colemak: n for toggle
				},
			},
		}
	end
}
