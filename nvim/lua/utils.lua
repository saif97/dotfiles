
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
