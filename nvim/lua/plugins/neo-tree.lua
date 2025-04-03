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
        ["n"] = "close_node",

        -- Map 'e' to move down
        ["e"] = "navigate_down", -- Moves the cursor down in the tree

        -- Map 'i' to go inside (expand directory or open file)
        ["i"] = "open",         -- Expands a directory or opens a file
        ["<Esc>"] = "close_window", -- Closes Neo-tree when pressing Escape twice
        ["f"] = "",
      },
    },
    filesystem = {
      follow_current_file = true,          -- Optional: Automatically focus the current file
      hijack_netrw_behavior = "open_current", -- Optional: Adjusts netrw behavior
      filtered_items = {
        visible = true,                    -- This will show hidden items by default
        hide_dotfiles = false,             -- This will show dotfiles
        hide_gitignored = false,           -- This will show gitignored files
      },
    },
  },
}
