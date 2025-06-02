return {
	"williamboman/mason.nvim",
	---@class MasonSettings
	opts = {
		ui = {
			keymaps = {
				install_package = "<D-i>",
				update_package = "<D-u>",
				update_all_packages = "<D-p>",
				check_package_version = "v",
			},
		},
	},
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		"williamboman/mason-lspconfig.nvim",
		"williamboman/mason-tool-installer.nvim",
	},
}
