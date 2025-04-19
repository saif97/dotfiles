require("config.codeCompanionConfigs")

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
      { "nvim-lua/plenary.nvim" },
      -- Test with blink.cmp
      -- {
      --   "saghen/blink.cmp",
      --   lazy = false,
      --   version = "*",
      --   opts = {
      --     keymap = {
      --       preset = "enter",
      --       ["<S-Tab>"] = { "select_prev", "fallback" },
      --       ["<Tab>"] = { "select_next", "fallback" },
      --     },
      --     cmdline = { sources = { "cmdline" } },
      --     sources = {
      --       default = { "lsp", "path", "buffer", "codecompanion" },
      --     },
      --   },
      -- },
      -- Test with nvim-cmp
      -- { "hrsh7th/nvim-cmp" },
    },
    opts = {
      --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
      strategies = {
        -- CHAT STRATEGY ----------------------------------------------------------
        chat = {
          adapter = "copilot",
          roles = {
            ---The header name for the LLM's messages
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(adapter)
              return "CodeCompanion (" .. adapter.formatted_name .. ")"
            end,

          ---The header name for your messages
            ---@type string
            user = "🚀🚀🚀 Saifinator 🚀🚀🚀",
          },
          keymaps = {
            send = {
              modes = {
                n = { "<CR>", "<C-s>" },
                i = "<CR>",
              },
              index = 2,
              callback = "keymaps.send",
              description = "Send",
            },
          },
        },
      },
      opts = {
        log_level = "DEBUG",
      },
    },
  },
}
