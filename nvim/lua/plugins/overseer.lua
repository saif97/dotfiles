return {
	"stevearc/overseer.nvim",

	config = function()
		require("overseer").setup({
			task_list = {
				bindings = {
					["<Esc>"] = "Close",
				},
			},
			templates = {
				"builtin",
			},
		})

		-- Register custom templates after setup
		require("config.overseerTemplates.overseerTemplateInit").setup()
	end,
}
