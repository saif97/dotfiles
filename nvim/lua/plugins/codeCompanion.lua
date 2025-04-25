require("config.codeCompanionConfigs")

local selected_adapter = "ollama"
if os.getenv("IS_PERSONAL_MACHINE") then
	selected_adapter = "copilot"
end

return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter",          build = ":TSUpdate" },
			{ "nvim-lua/plenary.nvim" },
			{ "MeanderingProgrammer/render-markdown.nvim" },
			-- Test with blink.cmp
			-- {
			--   "saghen/blink.cmp",
			--   lazy = false,
			--   version = "*",
			--   opts = {
			--     keymap = {
			--       preset = "enter",
			--       ["<S-Tab>"] = { "select_prev", "fallback" },
			--       ["<Tab>"] = { "select_next", "fallback" },
			--     },
			--     cmdline = { sources = { "cmdline" } },
			--     sources = {
			--       default = { "lsp", "path", "buffer", "codecompanion" },
			--     },
			--   },
			-- },
			-- Test with nvim-cmp
			-- { "hrsh7th/nvim-cmp" },
		},
		opts = {
			--Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
			strategies = {
				-- CHAT STRATEGY ----------------------------------------------------------
				chat = {
					adapter = selected_adapter,
					roles = {
						---The header name for the LLM's messages
						---@type string|fun(adapter: CodeCompanion.Adapter): string
						llm = function(adapter)
							return "CodeCompanion (" .. adapter.formatted_name .. ")"
						end,

						---The header name for your messages
						---@type string
						user = "🚀🚀🚀 Saifinator 🚀🚀🚀" .. selected_adapter,
					},
					keymaps = {
						send = {
							modes = {
								n = { "<CR>", "<C-s>" },
								i = "<C-CR>",
							},
							index = 2,
							callback = "keymaps.send",
							description = "Send",
						},
					},
				},
			},
			opts = {
				log_level = "DEBUG",
			},

			display = {
				chat = {
					separator = "───────────────────────────────────────────────────────────────", -- The separator between the different messages in the chat buffer
					show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
					show_settings = true, -- Show LLM settings at the top of the chat buffer?
					show_token_count = true, -- Show the token count for each response?
					start_in_insert_mode = true, -- Open the chat buffer in insert mode?
				},
			},
		},
	},
}
