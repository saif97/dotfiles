-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

require("utils")

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--

map_key({"i", "v"}, "tn", "<Esc>", {})

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map_key({ "n" },"<Esc>","<cmd>nohlsearch<CR>",{ desc = "Clear highlights on search when pressing <Esc> in normal mode" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which 
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map_key({ "t" }, "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

local allModes = { "n", "x", "v", "o" }

local builtin = require("telescope.builtin")
map_key("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
map_key("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
map_key("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
map_key("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
map_key("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
map_key("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
map_key("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
map_key("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
map_key("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map_key("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

map_key(allModes, "<Tab>", ">>", { desc = "Indent" })
map_key(allModes, "<S-Tab>", "<<", { desc = "Unindent" })

-- Up & down
map_key(allModes, "e", "j", { desc = "Move down" })
map_key(allModes, "u", "k", { desc = "Move up" })
map_key(allModes, "E", "5j", { desc = "Move down 5X" })
map_key(allModes, "U", "5k", { desc = "Move up 5X" })

map_key(allModes, "o", "i", { desc = "Insert mode" })

-- Map Enter to go to end of line in insert mode then enter to create a new line. That seems the only reliable way
map_key({ "n" }, "<CR>", "o", { desc = "Create a new line" })

-- map the left and to word and back
map_key(allModes, "n", "b", { desc = "Move to the previous word [left]" })
map_key(allModes, "i", "w", { desc = "Move to the next word [right]" })

map_key(allModes, "l", "0", { desc = "Move to the beginning of the line" })
map_key(allModes, "y", "$", { desc = "Move to the end of the line" })

map_key(allModes, "L", "u", { desc = "Undo" })
map_key(allModes, "Y", "<C-r>", { desc = "Redo" })

map_key(allModes, "b", "n", { desc = "Next occurrence of searched word" })
map_key(allModes, "B", "N", { desc = "Previous occurrence of searched word" })

map_key({ "n", "v" }, "d", '"_d', { desc = "Delete without copying" })
map_key({ "n", "v" }, "<Del>", '"_x', { desc = "Delete without copying" })

map_key(allModes, "w", '"_c', { desc = "Change w/o buffering" })
map_key(allModes, "W", '"_c', { desc = "Change w/o buffering" })

map_key(allModes, "c", "y", { desc = "Copy" })
map_key(allModes, "x", "d", { desc = "Cut" })

-- source the vimrc file
map_key({ "n" }, "<leader>sv", ":source $MYVIMRC<CR>", { desc = "[S]ource the [V]imrc file" })

map_key({ "n" }, "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Move to the end of the line" })

map_key({ "n" }, "<Esc>", function()
	vim.diagnostic.hide()
	vim.cmd("Neotree close")
end, { desc = "Hides all open panes" })

-- From kickstart Vim--

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-n>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-i>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-e>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-u>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- vim.keymap.set("n", "<C-u>", "gcc", {desc = "Comment line / multi-line"})

--  resize windows
vim.keymap.set("n", "<D-n>", "<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<D-i>", "<C-w>>", { desc = "Increase window width" })
vim.keymap.set("n", "<D-e>", "<C-w>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<D-u>", "<C-w>+", { desc = "Increase window height" })

vim.keymap.set("n", "<leader>wsh", "<C-w><C-s>", { desc = "[W]indow [s]plit [h]orizontal" })
vim.keymap.set("n", "<leader>wsv", "<C-w><C-v>", { desc = "[W]indow [s]plit [v]orizontal" })

-- Buffer stuff
-- map_key(allModes, "<C-n>", ":bnext<CR>")
-- map_key(allModes, "<C-i>", ":bprevious<CR>")

map_key(allModes, "<leader>qq", ":qa!<CR>", { desc = "[q]uit all buffers" })

-- LSP config
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
map_key({ "n" }, "<leader>cd", vim.diagnostic.setloclist, { desc = "Open [c]ode [d]iagnostic quickfix list" })

-- Insert mode mappings
vim.api.nvim_set_keymap('i', '<A-Left>', '<C-o>b', { noremap = true })  -- Alt+Left: Move word left
vim.api.nvim_set_keymap('i', '<A-Right>', '<C-o>w', { noremap = true }) -- Alt+Right: Move word right
vim.api.nvim_set_keymap('i', '<S-Left>', '<C-o>vh', { noremap = true })   -- Shift+Left: Select left
vim.api.nvim_set_keymap('i', '<S-Right>', '<C-o>vl', { noremap = true })  -- Shift+Right: Select right
vim.api.nvim_set_keymap('i', '<S-Up>', '<C-o>vk', { noremap = true })     -- Shift+Up: Select up
vim.api.nvim_set_keymap('i', '<S-Down>', '<C-o>vj', { noremap = true })    -- Shift+Down: Select down
vim.api.nvim_set_keymap('i', '<S-Home>', '<C-o>v0', { noremap = true })   -- Shift+Home: Select to line start
vim.api.nvim_set_keymap('i', '<S-End>', '<C-o>v$', { noremap = true })     -- Shift+End: Select to line end


