-- Helper function to check if we should use floating layout based on window size
local function get_cli_position()
	return vim.o.columns < 260 and "float" or "right"
end
-- Track the current layout state and terminal reference
local last_cli_position = nil
local terminal_ref = nil
return {
	"folke/sidekick.nvim",
	-- dir = "/Users/saifhakeam/dev/openSourcing/sidekick.nvim",
	opts = {
		-- add any options here
		cli = {
			mux = {
				backend = "zellij",
				enabled = true,
			},
			tools = { -- extra tools
				devbox = {
					cmd = { "devbox" },
				},
				ClaudeYOLO = {
					cmd = { "Claude --dangerously-skip-permissions" },
				},

			},
			win = {
				--- This is run when a new terminal is created, before starting it.
				--- Here you can change window options `terminal.opts`.
				---@param terminal sidekick.cli.Terminal
				config = function(terminal)
					local cli_position = get_cli_position()
					terminal.opts.layout = cli_position
					last_cli_position = cli_position
					terminal_ref = terminal -- save reference for later
				end,
				-- layout = "float", ---@type "float"|"left"|"bottom"|"top"|"right"  -- Now set dynamically in config()
				--- Options used when layout is "float"
				---@type vim.api.keyset.win_config
				float = {
					width = 0.9,
					height = 0.85,
					border = "rounded",
				},
				-- Options used when layout is "left"|"bottom"|"top"|"right"
				---@type vim.api.keyset.win_config
				split = {
					width = 150, -- static width in columns (set to 0 for default adaptive width)
					height = 0, -- set to 0 for default split height
				},
				--- CLI Tool Keymaps (default mode is `t`)
				---@type table<string, sidekick.cli.Keymap|false>
				keys = {
					buffers       = { "<D-b>", "buffers", mode = "nt", desc = "open buffer picker" },
					files         = { "<D-f>", "files", mode = "nt", desc = "open file picker" },
					prompt        = { "<D-p>", "prompt", mode = "t", desc = "insert prompt or context" },
					hide_ctrl_dot = {
						"<c-y>",
						function()
							if get_cli_position() == "float" then
								require("sidekick.cli").hide()
							else
								vim.cmd("wincmd p")
							end
						end,
						mode = "nt",
						desc = "hide or switch to the terminal window"
					},
				},
			}
		},
	},
	keys = {
		{
			"<c-;>",
			function()
				-- if there is a next edit, jump to it, otherwise apply it if any
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>" -- fallback to normal tab
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			"<c-y>",
			function()
				local cli = require("sidekick.cli")
				local new_cli_position = get_cli_position()

				-- If layout state changed, hide and update layout before showing
				if last_cli_position ~= nil and last_cli_position ~= new_cli_position and terminal_ref then
					cli.hide()
					terminal_ref.opts.layout = new_cli_position
					cli.toggle() -- show it back
				end

				-- Update the saved state
				last_cli_position = new_cli_position

				cli.focus()
			end,
			desc = "Sidekick Toggle Focus",
			mode = { "n", "v", "i", "t", "x" },
		},
		{
			"<leader>ia",
			function() require("sidekick.cli").toggle() end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>is",
			function() require("sidekick.cli").select({ filter = { installed = true } }) end,
			-- Or to select only installed tools:
			-- require("sidekick.cli").select({ filter = { installed = true } })
			desc = "Select CLI",
		},
		{
			"<leader>id",
			function() require("sidekick.cli").close() end,
			desc = "Detach a CLI Session",
		},
		{
			"<leader>it",
			function() require("sidekick.cli").send({ msg = "{this}" }) end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>if",
			function() require("sidekick.cli").send({ msg = "{file}" }) end,
			desc = "Send File",
		},
		{
			"<leader>iv",
			function() require("sidekick.cli").send({ msg = "{selection}" }) end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ip",
			function() require("sidekick.cli").prompt() end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
	},
}
