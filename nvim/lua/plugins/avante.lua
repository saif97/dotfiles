-- https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua

return {
	"yetone/avante.nvim",
	enabled = true, -- Disable this plugin

	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	opts = {
		-- add any opts here
		-- for example
		provider = "claude",
		claude = {
			endpoint = "https://api.anthropic.com",
			model = "claude-3-5-sonnet-20241022",
			temperature = 0,
			max_tokens = 4096,
		},

		openai = {
			endpoint = "https://api.openai.com/v1",
			model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
			timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
			temperature = 0,
			max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
			--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
		},
		mappings = {
			-- Full list of cmds https://github.com/yetone/avante.nvim/blob/6e1e2ac9f26b373bb7a40a53c43c304ab5244b4e/lua/avante/config.lua#L399-L437
			submit = {
				normal = "<CR>",
				insert = "<C-CR>",
			},
			cancel = {
				normal = { "<C-s>"}, -- S for Stop
				insert = { "<C-s>" },
			},
			sidebar = {
				close = nil,
				close_from_input = nil,
			},
			focus = "<leader>lf",
			stop = "<leader>ls",
			select_history = "<leader>lh",
		},

		windows = {
			width = 50, -- default % based on available width
		},
	},

	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		-- {
		--   -- support for image pasting
		--   "HakonHarnes/img-clip.nvim",
		--   event = "VeryLazy",
		--   opts = {
		--     -- recommended settings
		--     default = {
		--       embed_image_as_base64 = false,
		--       prompt_for_file_name = false,
		--       drag_and_drop = {
		--         insert_mode = true,
		--       },
		--       -- required for Windows users
		--       -- use_absolute_path = true,
		--     },
		--   },
		-- },
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
