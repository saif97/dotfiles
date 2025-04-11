function map_key(modes, from, to, options)
    local default_options = { noremap = true, silent = false }
    local merged_options = vim.tbl_extend("force", default_options, options or {})

    if type(modes) == "string" then
        modes = { modes }
    end

    for _, mode in ipairs(modes) do
        vim.keymap.set(mode, from, to, merged_options)
    end
end

if vim.g.vscode then
    local vscode = require('vscode')
    
    function callVscodeAction(modes, from, actionName, vscodeOptions)
        if type(modes) == "string" then
            modes = { modes }
        end

        for _, mode in ipairs(modes) do
            vim.keymap.set(mode, from, function() vscode.action(actionName, vscodeOptions) end, {})
        end
    end
else
    -- Neovim-only configurations
end
