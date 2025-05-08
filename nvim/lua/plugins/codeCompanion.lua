require("config.codeCompanionConfigs")
require("utils")

local selected_adapter = "ollama"
if isPersonalMachine() then
	selected_adapter = "copilot"
end

return {
	{
		"olimorris/codecompanion.nvim",
		enabled = false,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter",           build = ":TSUpdate" },
			{ "nvim-lua/plenary.nvim" },
			{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
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
				inline = {
					adapter = selected_adapter,
				},
				cmd = {
					adapter = selected_adapter,
				},
			},
			opts = {
				log_level = "DEBUG",
			},
		},
	},
}
