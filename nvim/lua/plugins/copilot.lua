return {
  "zbirenbaum/copilot.lua",
  commit = "3cd5086c28c5769f5db147721f457a3e081de254",
  enabled = isPersonalMachine(),
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      panel = {
        enabled = true,
        auto_refresh = true,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = "<C-j>",
          prev = "<C-k>",
          dismiss = "<C-h>",
        },
      },
    })
  end,
}
