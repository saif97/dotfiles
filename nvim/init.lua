local keymaps = require("keymaps")
keymaps.setup()
require("vimOptions")

if vim.g.vscode then
	keymaps.setupVScode()
else
	-- Neovim-only configurations
	keymaps.setupNvimPreLazy()
	require("config.lazy")
	require("config.lsp")
	require("userCmds")
	keymaps.setupNvim()
end
require("autoCmd")
