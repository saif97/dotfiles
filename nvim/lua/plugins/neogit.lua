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
			-- Hides the hints at the top of the status buffer
			disable_hint = false,
			-- Disables changing the buffer highlights based on where the cursor is.
			disable_context_highlighting = false,
			-- Disables signs for sections/items/hunks
			disable_signs = false,
			-- Offer to force push when branches diverge
			prompt_force_push = true,
			-- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
			-- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
			-- normal mode.
			disable_insert_on_commit = "auto",
			-- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
			-- events.
			filewatcher = {
				interval = 1000,
				enabled = true,
			},
			-- "ascii"   is the graph the git CLI generates
			-- "unicode" is the graph like https://github.com/rbong/vim-flog
			-- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
			graph_style = "kitty",
			-- Show relative date by default. When set, use `strftime` to display dates
			commit_date_format = nil,
			log_date_format = nil,
			-- Show message with spinning animation when a git command is running.
			process_spinner = true,
			-- Used to generate URL's for branch popup action "pull request".
			git_services = {
				["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
				["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
				["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
				["azure.com"] = "https://dev.azure.com/${owner}/_git/${repository}/pullrequestcreate?sourceRef=${branch_name}&targetRef=${target}",
			},
			-- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
			-- sorter instead. By default, this function returns `nil`.
			telescope_sorter = function()
				return require("telescope").extensions.fzf.native_fzf_sorter()
			end,
			-- Persist the values of switches/options within and across sessions
			remember_settings = true,
			-- Scope persisted settings on a per-project basis
			use_per_project_settings = true,
			-- Table of settings to never persist. Uses format "Filetype--cli-value"
			ignored_settings = {},
			-- Configure highlight group features
			highlight = {
				italic = true,
				bold = true,
				underline = true
			},
			-- Set to false if you want to be responsible for creating _ALL_ keymappings
			use_default_keymaps = false,
			-- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
			-- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
			auto_refresh = true,
			-- Value used for `--sort` option for `git branch` command
			-- By default, branches will be sorted by commit date descending
			-- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
			-- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
			sort_branches = "-committerdate",
			-- Default for new branch name prompts
			initial_branch_name = "",
			-- Change the default way of opening neogit
			kind = "tab",
			-- Floating window style
			floating = {
				relative = "editor",
				width = 0.8,
				height = 0.7,
				style = "minimal",
				border = "rounded",
			},
			-- Disable line numbers
			disable_line_numbers = true,
			-- Disable relative line numbers
			disable_relative_line_numbers = true,
			-- The time after which an output console is shown for slow running commands
			console_timeout = 2000,
			-- Automatically show console if a command takes more than console_timeout milliseconds
			auto_show_console = true,
			-- Automatically close the console if the process exits with a 0 (success) status
			auto_close_console = true,
			notification_icon = "󰊢",
			status = {
				show_head_commit_hash = true,
				recent_commit_count = 10,
				HEAD_padding = 10,
				HEAD_folded = false,
				mode_padding = 3,
				mode_text = {
					M = "modified",
					N = "new file",
					A = "added",
					D = "deleted",
					C = "copied",
					U = "updated",
					R = "renamed",
					DD = "unmerged",
					AU = "unmerged",
					UD = "unmerged",
					UA = "unmerged",
					DU = "unmerged",
					AA = "unmerged",
					UU = "unmerged",
					["?"] = "",
				},
			},
			commit_editor = {
				kind = "tab",
				show_staged_diff = true,
				-- Accepted values:
				-- "split" to show the staged diff below the commit editor
				-- "vsplit" to show it to the right
				-- "split_above" Like :top split
				-- "vsplit_left" like :vsplit, but open to the left
				-- "auto" "vsplit" if window would have 80 cols, otherwise "split"
				staged_diff_split_kind = "vsplit",
				spell_check = true,
			},
			commit_select_view = {
				kind = "tab",
			},
			commit_view = {
				kind = "vsplit",
				verify_commit = vim.fn.executable("gpg") == 1, -- Can be set to true or false, otherwise we try to find the binary
			},
			log_view = {
				kind = "tab",
			},
			rebase_editor = {
				kind = "auto",
			},
			reflog_view = {
				kind = "tab",
			},
			merge_editor = {
				kind = "auto",
			},
			preview_buffer = {
				kind = "floating_console",
			},
			popup = {
				kind = "split",
			},
			stash = {
				kind = "tab",
			},
			refs_view = {
				kind = "tab",
			},
			signs = {
				-- { CLOSED, OPENED }
				hunk = { "", "" },
				item = { ">", "v" },
				section = { ">", "v" },
			},
			-- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
			integrations = {
				-- If enabled, use telescope for menu selection rather than vim.ui.select.
				-- Allows multi-select and some things that vim.ui.select doesn't.
				telescope = false,
				-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
				-- The diffview integration enables the diff popup.
				--
				-- Requires you to have `sindrets/diffview.nvim` installed.
				diffview = true,

				-- If enabled, uses fzf-lua for menu selection. If the telescope integration
				-- is also selected then telescope is used instead
				-- Requires you to have `ibhagwan/fzf-lua` installed.
				fzf_lua = false,

				-- If enabled, uses mini.pick for menu selection. If the telescope integration
				-- is also selected then telescope is used instead
				-- Requires you to have `echasnovski/mini.pick` installed.
				mini_pick = nil,

				-- If enabled, uses snacks.picker for menu selection. If the telescope integration
				-- is also selected then telescope is used instead
				-- Requires you to have `folke/snacks.nvim` installed.
				snacks = true,
			},
			sections = {
				-- Reverting/Cherry Picking
				sequencer = {
					folded = false,
					hidden = false,
				},
				untracked = {
					folded = false,
					hidden = false,
				},
				unstaged = {
					folded = false,
					hidden = false,
				},
				staged = {
					folded = false,
					hidden = false,
				},
				stashes = {
					folded = true,
					hidden = false,
				},
				unpulled_upstream = {
					folded = true,
					hidden = false,
				},
				unmerged_upstream = {
					folded = false,
					hidden = false,
				},
				unpulled_pushRemote = {
					folded = true,
					hidden = false,
				},
				unmerged_pushRemote = {
					folded = false,
					hidden = false,
				},
				recent = {
					folded = true,
					hidden = false,
				},
				rebase = {
					folded = true,
					hidden = false,
				},
			},
			mappings = {
				commit_editor = {
					["q"] = "Close",
					["<c-CR>"] = "Submit",
					["<c-b>"] = "Abort",
					["<m-p>"] = "PrevMessage",
					["<m-n>"] = "NextMessage",
					["<m-r>"] = "ResetMessage",
				},
				commit_editor_I = {
					["<c-c><c-c>"] = "Submit",
					["<c-c><c-k>"] = "Abort",
				},
				rebase_editor = {
					["p"] = "Pick",
					["r"] = "Reword",
					["e"] = "Edit",
					["s"] = "Squash",
					["f"] = "Fixup",
					["x"] = "Execute",
					["d"] = "Drop",
					["b"] = "Break",
					["q"] = "Close",
					["<cr>"] = "OpenCommit",
					["gk"] = "MoveUp",
					["gj"] = "MoveDown",
					["<c-c><c-c>"] = "Submit",
					["<c-c><c-k>"] = "Abort",
					["[c"] = "OpenOrScrollUp",
					["]c"] = "OpenOrScrollDown",
				},
				rebase_editor_I = {
					["<c-c><c-c>"] = "Submit",
					["<c-c><c-k>"] = "Abort",
				},
				finder = {
					["<cr>"] = "Select",
					["<c-c>"] = "Close",
					["<esc>"] = "Close",
					["<c-n>"] = "Next",
					["<c-p>"] = "Previous",
					["<down>"] = "Next",
					["<up>"] = "Previous",
					["<tab>"] = "InsertCompletion",
					["<c-y>"] = "CopySelection",
					["<space>"] = "MultiselectToggleNext",
					["<s-space>"] = "MultiselectTogglePrevious",
					["<c-j>"] = "NOP",
					["<ScrollWheelDown>"] = "ScrollWheelDown",
					["<ScrollWheelUp>"] = "ScrollWheelUp",
					["<ScrollWheelLeft>"] = "NOP",
					["<ScrollWheelRight>"] = "NOP",
					["<LeftMouse>"] = "MouseClick",
					["<2-LeftMouse>"] = "NOP",
				},
				-- Setting any of these to `false` will disable the mapping.
				popup = {
					["?"] = "HelpPopup",
					["A"] = "CherryPickPopup",
					["d"] = "DiffPopup",
					["M"] = "RemotePopup",
					["P"] = "PushPopup",
					["X"] = "ResetPopup",
					["Z"] = "StashPopup",
					["<c-i>"] = "IgnorePopup",
					["t"] = "TagPopup",
					["b"] = "BranchPopup",
					["B"] = "BisectPopup",
					["w"] = "WorktreePopup",
					["c"] = "CommitPopup",
					["f"] = "FetchPopup",
					["l"] = "LogPopup",
					["m"] = "MergePopup",
					["p"] = "PullPopup",
					["r"] = "RebasePopup",
					["v"] = "RevertPopup",
				},
				status = {
					["e"] = "MoveDown",
					["u"] = "MoveUp",
					["<C-o>"] = "OpenTree",
					["q"] = "Close",
					["I"] = "InitRepo",
					["1"] = "Depth1",
					["2"] = "Depth2",
					["3"] = "Depth3",
					["4"] = "Depth4",
					["Q"] = "Command",
					["i"] = "Toggle",
					["n"] = "Toggle",
					["zo"] = "OpenFold",
					["x"] = "Discard",
					["s"] = "Stage",
					["S"] = "StageUnstaged",
					["<c-s>"] = "StageAll",
					["<C-u>"] = "Unstage",
					["K"] = "Untrack",
					["<c-U>"] = "UnstageStaged",
					["y"] = "ShowRefs",
					["$"] = "CommandHistory",
					["Y"] = "YankSelected",
					["<c-r>"] = "RefreshBuffer",
					["<cr>"] = "GoToFile",
					["<s-cr>"] = "PeekFile",
					["<c-v>"] = "VSplitOpen",
					["<c-x>"] = "SplitOpen",
					["<c-t>"] = "TabOpen",
					["{"] = "GoToPreviousHunkHeader",
					["}"] = "GoToNextHunkHeader",
					["[c"] = "OpenOrScrollUp",
					["]c"] = "OpenOrScrollDown",
					["<c-k>"] = "PeekUp",
					["<c-j>"] = "PeekDown",
					["<c-n>"] = "NextSection",
					["<c-p>"] = "PreviousSection",
				},
			},
		}
	end
}
