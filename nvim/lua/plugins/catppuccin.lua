return { 
    "catppuccin/nvim",
    name = "catppuccin", priority = 1000,
    config = function()
        vim.cmd.colorscheme "catppuccin"
        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#6e738d' })
    end
}
