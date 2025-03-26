
function map_key(modes, from, to, options)
    for _, mode in ipairs(modes) do
        vim.keymap.set(mode, from, to, {noremap = true, silent = true})
    end
end


