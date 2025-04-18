-- Using Colemak-inspired navigation

require("utils")

-- Helper to define keymappings for all commonly used modes
local allModes = { "n", "x", "v", "o" }

-- [[ Section: Colemak-inspired Navigation ]]

-- Basic movement (Colemak-inspired)
map_key(allModes, "e", "j", { desc = "Move down" })
map_key(allModes, "u", "k", { desc = "Move up" })
map_key(allModes, "n", "b", { desc = "Move to the previous word" })
map_key(allModes, "i", "w", { desc = "Move to the next word" })
map_key(allModes, "l", "0", { desc = "Move to the beginning of the line" })
map_key(allModes, "y", "$", { desc = "Move to the end of the line" })

-- Fast movement
map_key(allModes, "E", "5j", { desc = "Move down 5 lines" })
map_key(allModes, "U", "5k", { desc = "Move up 5 lines" })

-- Insert mode access
map_key(allModes, "o", "i", { desc = "Enter insert mode" })
map_key({ "n" }, "<CR>", "o", { desc = "Create a new line" })

-- [[ Section: Editing ]]

-- Indentation
map_key(allModes, "<Tab>", ">>", { desc = "Indent" })
map_key(allModes, "<S-Tab>", "<<", { desc = "Unindent" })

-- Undo/Redo
map_key(allModes, "L", "u", { desc = "Undo" })
map_key(allModes, "Y", "<C-r>", { desc = "Redo" })

-- Copy/Cut/Change
map_key(allModes, "c", "y", { desc = "Copy" })
map_key(allModes, "x", "d", { desc = "Cut" })
map_key(allModes, "w", '"_c', { desc = "Change w/o copying to register" })
map_key(allModes, "W", '"_c', { desc = "Change w/o copying to register" })

-- Delete without copying to register
map_key({ "n", "v" }, "d", '"_d', { desc = "Delete without copying" })
map_key({ "n", "v" }, "<Del>", '"_x', { desc = "Delete without copying" })

-- Search navigation
map_key(allModes, "b", "n", { desc = "Next search match" })
map_key(allModes, "B", "N", { desc = "Previous search match" })

if vim.g.vscode then
	local vscode = require("vscode")
	-- callVscodeAction(allModes, "<leader>ag", "workbench.action.chat.openEditSession", {})
	--
	--[[ Cursor AI keymaps  ]]
	callVscodeActions(allModes, "<leader>an", "composerMode.agent") -- Cursor AI Agent
	callVscodeActions(allModes, "<leader>ac", "composerMode.chat") -- Cursor AI Ask mode

	callVscodeActions(allModes, "<Esc><Esc>", {
		"composer.closeComposerTab",
		"workbench.action.closeSidebar",
		"workbench.action.closePanel",
	}, true) -- Cursor AI Edit

	callVscodeActions(allModes, "/", "actions.find")
	callVscodeActions(allModes, "b", "editor.action.nextMatchFindAction")
	callVscodeActions(allModes, "B", "editor.action.previousMatchFindAction")
else -- Neovim only Configs
	-- Clear highlights and close panels
	map_key({ "n" }, "<Esc>", function()
		vim.cmd("nohlsearch")
		vim.diagnostic.hide()
		vim.cmd("Neotree close")
	end, { desc = "Clear highlights and close panels" })

	-- Exit terminal mode with Escape
	map_key({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

	-- Source config file
	map_key({ "n" }, "<leader>sv", ":source $MYVIMRC<CR>", { desc = "[S]ource the [V]imrc file" })

	-- Quick exit
	map_key(allModes, "<leader>qq", ":qa!<CR>", { desc = "[Q]uit all buffers" })

	-- [[ Section: Window Management ]]

	-- Window navigation
	vim.keymap.set("n", "<C-n>", "<C-w><C-h>", { desc = "Focus left window" })
	vim.keymap.set("n", "<C-i>", "<C-w><C-l>", { desc = "Focus right window" })
	vim.keymap.set("n", "<C-e>", "<C-w><C-j>", { desc = "Focus lower window" })
	vim.keymap.set("n", "<C-u>", "<C-w><C-k>", { desc = "Focus upper window" })

	-- Window resizing
	local resizeMultiplier = 10
	vim.keymap.set("n", "<D-n>", resizeMultiplier .. "<C-w><", { desc = "Decrease window width" })
	vim.keymap.set("n", "<D-i>", resizeMultiplier .. "<C-w>>", { desc = "Increase window width" })
	vim.keymap.set("n", "<D-e>", resizeMultiplier .. "<C-w>-", { desc = "Decrease window height" })
	vim.keymap.set("n", "<D-u>", resizeMultiplier .. "<C-w>+", { desc = "Increase window height" })

	vim.keymap.set("n", "<leader>wh", "<C-w>s", { desc = "[W]indow split [H]orizontally" })
	vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "[W]indow split [V]ertically" })
	vim.keymap.set("n", "<leader>wq", "<C-w>q", { desc = "[W]indow Close" })

	-- [[ Section: Buffer Navigation ]]

	-- Buffer switching
	map_key({ "n", "i" }, "<C-.>", ":bnext<CR>", { desc = "Next buffer" })
	map_key({ "n", "i" }, "<C-,>", ":bprevious<CR>", { desc = "Previous buffer" })
	map_key("n", "<leader><leader>", require("telescope.builtin").buffers, { desc = "Find buffers" })

	-- [[ Section: File Explorer and Projects ]]

	map_key({ "n" }, "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "Open file explorer" })
	map_key({ "n" }, "<leader>sp", ":SessionSearch<CR>", { desc = "[S]earch [P]rojects" })

	-- [[ Section: Telescope Integration ]]

	local builtin = require("telescope.builtin")
	map_key("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
	map_key("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
	map_key("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
	map_key("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	map_key("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
	map_key("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
	map_key("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
	map_key("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
	map_key("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
	map_key({ "n" }, "<leader>sc", ":Telescope commands<CR>", { desc = "[S]earch [C]ommands" })

	-- [[ Section: LSP Integration ]]

	map_key("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
	map_key("n", "<leader>cd", vim.diagnostic.setloclist, { desc = "[C]ode [D]iagnostic list" })

	-- [[ Section: Plugin-specific ]]

	-- Code Companion
	map_key({ "n" }, "<leader>ap", ":CodeCompanionActions<CR>", { desc = "[A]i Command [P]allet" })
	map_key({ "n" }, "<leader>ac", ":CodeCompanionChat Toggle<CR>", { desc = "[C]ode [C]ompanion chat" })

	map_key({ "n" }, "<leader>rc", ":luafile %<CR>", { desc = "[r]eload [c]onfigs" })
	map_key({ "n" }, "<leader>ot", "", { desc = "[r]eload [c]onfigs" })

	-- [[ Section: Insert mode text editing ]]
	map_key({ "i" }, "<D-l>", "<Home>", { desc = "" })
	map_key({ "i" }, "<D-y>", "<End>", { desc = "" })

	-- support for option + backspace & delete
	map_key("i", "<M-BS>", "<C-w>", { desc = "" })
	map_key("i", "<M-Del>", "<C-o>dw", { desc = "" })

	-- support for option + arrows to move words 
	map_key({"i", "v", "n"}, "<M-f>", "<C-right>", { desc = "" })
	map_key({"i", "v", "n"}, "<M-b>", "<C-left>", { desc = "" })
end
