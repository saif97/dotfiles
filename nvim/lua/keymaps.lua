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

local allModes = {'n', 'x', 'v', 'o'}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

map_key(allModes, '<Tab>', '>>', { desc = 'Indent' })
map_key(allModes, '<S-Tab>', '<<', { desc = 'Unindent' })


-- Up & down
map_key(allModes, 'e', 'j', { desc = 'Move down' })
map_key(allModes, 'u', 'k', { desc = 'Move up' })
map_key(allModes, 'E', '5j', { desc = 'Move down 5X' })
map_key(allModes, 'U', '5k', { desc = 'Move up 5X' })

map_key(allModes, 'o', 'i', { desc = 'Insert mode' })

-- Map Enter to go to end of line in insert mode then enter to create a new line. That seems the only reliable way
map_key({'n'}, '<CR>', 'o', { desc = 'Create a new line' })

-- map the left and to word and back
map_key(allModes, 'n', 'b', { desc = 'Move to the previous word [left]' })
map_key(allModes, 'i', 'w', { desc = 'Move to the next word [right]' })

map_key(allModes, 'l', '0', { desc = 'Move to the beginning of the line' })
map_key(allModes, 'y', '$', { desc = 'Move to the end of the line' })

map_key(allModes, 'L', 'u', { desc = 'Undo' })
map_key(allModes, 'Y', '<C-r>', { desc = 'Redo' })

map_key(allModes, 'b', 'n', { desc = 'Next occurrence of searched word' })
map_key(allModes, 'B', 'N', { desc = 'Previous occurrence of searched word' })

map_key({'n', 'v'}, 'd', '"_d', { desc = 'Delete without copying' })
map_key({'n', 'v'}, '<Del>', '"_x', { desc = 'Delete without copying' })

map_key(allModes, 'w', '"_c', { desc = 'Change w/o buffering' })
map_key(allModes, 'W', '"_c', { desc = 'Change w/o buffering' })

map_key(allModes, 'c', 'y', { desc = 'Copy' })
map_key(allModes, 'x', 'd', { desc = 'Cut' })

-- source the vimrc file
map_key({'n'}, '<leader>sv', ':source $MYVIMRC<CR>', { desc = '[S]ource the [V]imrc file' })

map_key({'n'}, '<leader>e', ':Neotree filesystem reveal left<CR>', { desc = 'Move to the end of the line' })


