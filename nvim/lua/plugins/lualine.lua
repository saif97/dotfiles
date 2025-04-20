return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local custom_gruvbox = require("lualine.themes.catppuccin")
    custom_gruvbox.inactive.a.bg = "#8bd5ca"
    custom_gruvbox.inactive.a.fg = "#181926"

    require("lualine").setup({
      options = {
        theme = custom_gruvbox,
        globalstatus = false,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                  .. "->"
                  .. vim.fn.expand('%:t')
            end,
            icon = "󱧽", -- Customize the icon if needed
            color = { fg = "#8aadf4" },
          },
          {
            "filename",
            path = 1,
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },

      -- inactive_winbar = {
      -- 	lualine_a = { { "filename", color = { fg = "#232634" } } }, -- customize font and background color
      -- 	lualine_b = {},
      -- 	lualine_c = {},
      -- 	lualine_x = {},
      -- 	lualine_y = {},
      -- 	lualine_z = {},
      -- },
    })
  end,
}
