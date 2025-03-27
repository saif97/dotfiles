return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
  window = {
    mappings = {
      ["<BS>"] = "", -- Disables backspace navigation
      -- Map 'u' to move up
      -- ["u"] = "navigate_up", -- Moves the cursor up in the tree

      -- Map 'e' to move down
      ["e"] = "navigate_down", -- Moves the cursor down in the tree

      -- Map 'i' to go inside (expand directory or open file)
      ["i"] = "toggle_node", -- Expands a directory or opens a file

      -- Map 'n' to go outside (parent directory)
      ["n"] = "navigate_up_dir", -- Goes to the parent directory
    },
  },

  },
}
