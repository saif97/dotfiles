require("vimOptions")

if vim.g.vscode then
    -- VSCode-specific configurations
    -- 
    
else
    -- Neovim-only configurations
    require("config.lazy")
    
end
require("keymaps")
require("autoCmd")
require("playground")

