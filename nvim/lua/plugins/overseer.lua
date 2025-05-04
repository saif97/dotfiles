return {
	"stevearc/overseer.nvim",

	config = function()
		require("overseer").setup({
			task_list = {
				bindings = {
					["<Esc>"] = "Close",
				},
			},
			require("config.overseerTemplates.overseerTemplateInit").setup(),

			templates = {
				-- Load global templates
				"builtin",
			},
		})
	end,
}
