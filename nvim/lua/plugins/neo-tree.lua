return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		window = {
			mappings = {
				["<BS>"] = "", -- Disables backspace navigation
				["."] = "", -- Disables backspace navigation
				-- Map 'u' to move up
				-- ["u"] = "navigate_up", -- Moves the cursor up in the tree
				["n"] = "close_node",
				["<Left>"] = "close_node",
				

				-- Map 'e' to move down
				["e"] = "", -- Moves the cursor down in the tree
				["X"] = "toggle_auto_expand_width",

				-- Map 'i' to go inside (expand directory or open file)
				["i"] = "open",         -- Expands a directory or opens a file
				["<Right>"] = "open",         -- Expands a directory or opens a file
				["<Esc>"] = "close_window", -- Closes Neo-tree when pressing Escape twice

				["<leader>pn"] = {
					desc = "Copy [p]ath but [f]ilename only",
					function(state)
						local node = state.tree:get_node()
						local filename = node.name
						vim.fn.setreg("+", filename)
						vim.notify("Copied: " .. filename)
					end,
				},
				["<leader>pa"] = {
					desc = "Copy [p]ath [a]bsolute for the selected file",
					function(state)
						local node = state.tree:get_node()
						local filename = node:get_id()
						vim.fn.setreg("+", filename)
						vim.notify("Copied: " .. filename)
					end,
				},
				["<leader>pr"] = {
					desc = "Copy [p]ath [r]elative to the selected file",
					function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
						vim.fn.setreg("+", relative_path)
						vim.notify("Copied: " .. relative_path)
					end,
				},
				["<leader>od"] = {
					desc = "[o]pen [d]irectory",
					function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						filepath = vim.fn.fnamemodify(filepath, ":h")
						vim.fn.system("open " .. filepath)
						vim.notify("opening: " .. filepath)
					end,
				},
				["<space>"] = "",
			},
		},
		filesystem = {
			follow_current_file = {
				enabled = true,
			},
			hijack_netrw_behavior = "open_current", -- Optional: Adjusts netrw behavior
			filtered_items = {
				visible = false,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_by_name = {
					-- ".DS_Store",
					"node_modules",
					"__pycache__",
					".pytest_cache",

				},
				never_show = {
					".DS_Store",
				}
			},
		},
	},
}
