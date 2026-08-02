return {
	{
		"https://github.com/sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewRefresh" },
		opts = {
			enhanced_diff_hl = true,
		},
	},
	{
		"makefinks/doubt.nvim",
		enabled = isPersonalMachine(),
		commit = "4f474018a06db31cb40d4577876662ac931d537f",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("doubt").setup()
		end,
	},
}
