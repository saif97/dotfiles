return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      auto_install = true,
      sync_install = false,
      highlight = { enable = true },
      indent = {
        enable = true,
        disable = { "markdown" }, -- disable treesitter indent for markdown
      },
    })
  end,
}
