-- Function to navigate to most recent window in the specified direction
--
-- Given a file, 
--
local function navigate_to_recent(direction)
  
  
  
end

-- Map all directions
-- vim.keymap.set('n', '<C-n>', function() navigate_to_recent("left") end, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-i>', function() navigate_to_recent("right") end, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-e>', function() navigate_to_recent("down") end, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-u>', function() navigate_to_recent("up") end, { noremap = true, silent = true })

-- Function to reload the current file
local function reload_file()
  vim.notify("Reloading current file...", vim.log.levels.INFO)
  vim.notify("File reloaded successfully", vim.log.levels.INFO)
end

-- Map to a key for easy reloading
vim.keymap.set("n", "<leader>pl", function()
  navigate_to_recent("right")
end, { noremap = true, silent = true, desc = "Reload current file" })
vim.keymap.set("n", "<leader>pu", ":source %<CR>", { noremap = true, silent = true, desc = "Reload current file" })

-- You can also use any of these commands directly in Neovim:
-- :e or :edit - Reload the current buffer
-- :e! or :edit! - Forcibly reload, discarding unsaved changes
-- :checktime - Check if file has been modified outside of Neovim
