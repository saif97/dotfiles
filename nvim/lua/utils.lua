function map_key(modes, from, to, options)
    for _, mode in ipairs(modes) do
        vim.keymap.set(mode, from, to, options)
    end
end
