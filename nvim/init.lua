
-- Set vim options.
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

require("config.lazy")

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"


function map_key(modes, from, to, options)
    for _, mode in ipairs(modes) do
        vim.keymap.set(mode, from, to, options)
    end
end


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


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
