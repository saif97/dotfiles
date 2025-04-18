require("config.codeCompanionConfigs")

return {
	"olimorris/codecompanion.nvim",
	config = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},

	opts = {
		adapters = adapter_lib,
		prompt_library = prompt_lib,
		strategies = {
			chat = {
				adapter = "copilot",
				roles = {
					user = "olimorris",
				},
				keymaps = {
					send = {
						modes = {
							i = { "<C-CR>", "<C-s>" },
						},
					},
					completion = {
						modes = {
							i = "<C-x>",
						},
					},
				},
				slash_commands = {
					["buffer"] = {
						opts = {
							provider = "snacks",
							keymaps = {
								modes = {
									i = "<C-b>",
								},
							},
						},
					},
					["help"] = {
						opts = {
							provider = "snacks",
							max_lines = 1000,
						},
					},
					["file"] = {
						opts = {
							provider = "snacks",
						},
					},
					["symbols"] = {
						opts = {
							provider = "snacks",
						},
					},
				},
				tools = {
					vectorcode = {
						description = "Run VectorCode to retrieve the project context.",
						callback = function()
							return require("vectorcode.integrations").codecompanion.chat.make_tool()
						end,
					},
				},
			},
			inline = { adapter = "copilot" },
		},
		display = {
			action_palette = {
				provider = "default",
			},
			chat = {
				-- show_references = true,
				-- show_header_separator = false,
				-- show_settings = false,
			},
			diff = {
				enabled = true,
				close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
				layout = "vertical", -- vertical|horizontal split for default provider
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "mini_diff", -- default|mini_diff
			},
		},
		opts = {
			log_level = "DEBUG",
		},
	},
}

