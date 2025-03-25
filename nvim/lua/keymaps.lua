-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

require ("utils")

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map_key({'n'}, '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights on search when pressing <Esc> in normal mode' })

-- Diagnostic keymaps
map_key({'n'}, '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map_key({'t'}, '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


-- Up & down
map_key({'n', 'x', 'v'}, 'e', 'j', { desc = 'Move down' })
map_key({'n', 'x', 'v'}, 'u', 'k', { desc = 'Move up' })
map_key({'n', 'x', 'v'}, 'E', '5j', { desc = 'Move down 5X' })
map_key({'n', 'x', 'v'}, 'U', '5k', { desc = 'Move up 5X' })

map_key({'n', 'x', 'v'}, 'o', 'i', { desc = 'Insert mode' })

-- Map Enter to go to end of line in insert mode then enter to create a new line. That seems the only reliable way
map_key({'n'}, '<CR>', 'o', { desc = 'Create a new line' })

-- map the left and to word and back
map_key({'n', 'x', 'v'}, 'n', 'b', { desc = 'Move to the previous word [left]' })
map_key({'n', 'x', 'v'}, 'i', 'w', { desc = 'Move to the next word [right]' })

map_key({'n', 'x', 'v'}, 'l', '0', { desc = 'Move to the beginning of the line' })
map_key({'n', 'x', 'v'}, 'y', '$', { desc = 'Move to the end of the line' })

map_key({'n', 'x', 'v'}, 'b', 'n', { desc = 'Next occurrence of searched word' })
map_key({'n', 'x', 'v'}, 'B', 'N', { desc = 'Previous occurrence of searched word' })

-- source the vimrc file
map_key({'n'}, '<leader>sv', ':source $MYVIMRC<CR>', { desc = '[S]ource the [V]imrc file' })
