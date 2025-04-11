require("vimOptions")

if vim.g.vscode then
    -- VSCode-specific configurations
    
else
    -- Neovim-only configurations
    require("config.lazy")
    require("autoCmd")
end
require("keymaps")