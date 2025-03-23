-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",


-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

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


local function map_key(modes, from, to, options)
    for _, mode in ipairs(modes) do
        vim.keymap.set(mode, from, to, options)
    end
end


-- Up & down
map_key({'n', 'x'}, 'e', 'j', { desc = 'Move down' })
map_key({'n', 'x'}, 'u', 'k', { desc = 'Move up' })
map_key({'n', 'x'}, 'o', 'i', { desc = 'Move to the end of the line' })

-- Map Enter to go to end of line in insert mode then enter to create a new line. That seems the only reliable way
map_key({'n'}, '<CR>', 'o', { desc = 'Create a new line' })

-- map the left and to word and back
map_key({'n', 'x'}, 'n', 'b', { desc = 'Move to the previous word' })
map_key({'n', 'x'}, 'i', 'w', { desc = 'Move to the next word' })
map_key({'n', 'x'}, 'b', 'n', { desc = 'Move to the previous word' })

-- source the vimrc file
map_key({'n'}, '<leader>sv', ':source $MYVIMRC<CR>', { desc = 'Source the vimrc file' })
