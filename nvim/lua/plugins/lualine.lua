return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local custom_gruvbox = require("lualine.themes.gruvbox")
        custom_gruvbox.inactive.a.bg = "#112233"

        require("lualine").setup({
            theme = custom_gruvbox,
            inactive_sections = {
                lualine_a = { "filename" },
                lualine_b = {},
                lualine_c = {},
                lualine_x = { "location" },
            },
        })
    end,
}
