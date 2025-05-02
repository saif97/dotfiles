local keymaps = require("keymaps")
keymaps.setup()
require("vimOptions")

if vim.g.vscode then
	keymaps.setupVScode()
else
	-- Neovim-only configurations
	require("config.lazy")
	keymaps.setupNvim()
end
require("autoCmd")
require("playground")
