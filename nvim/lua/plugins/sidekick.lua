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
		},
	},
	keys = {
		{
			"<S-tab>",
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
				if vim.bo.filetype == "sidekick_terminal" then
					vim.cmd("wincmd p")
				else
					require("sidekick.cli").focus()
				end
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
			function() require("sidekick.cli").select() end,
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
