-- Using Colemak-inspired navigation

require("utils")

-- Helper to define keymappings for all commonly used modes
-- Mode letters:
--   "n" = normal mode (default mode for navigation and commands)
--   "x" = visual mode (character-wise selection)
--   "v" = visual mode (includes visual block mode)
--   "o" = operator-pending mode (waiting for motion after operator like d, c, y)
--   "i" = insert mode
--   "t" = terminal mode
local allModes = { "n", "x", "v", "o" }
local M = {}

-- This is common keymaps between VScode & Nvim
function M.setup()
	map_key("n", "q", "<Nop>", { desc = "Disable 'q' key in normal mode" })
	map_key("n", "Q", "q", { desc = "Record macro" })

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
	map_key({ "n", "o" }, "o", "i", { desc = "Enter insert mode" })
	map_key("v", "o", "<Esc>i", { desc = "Enter insert mode" })
	map_key({ "n", "x", "v" }, "<CR>", function ()
		return vim.bo.buftype == "terminal" and "<C-\\><C-n>" or "o"
	end, { desc = "", expr = true })
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
end

function M.setupNvimPreLazy()
	vim.g.bullets_set_mappings = 0
	vim.g.bullets_delete_last_bullet_if_empty = 2
	vim.g.bullets_checkbox_markers = " ○◐●✓"
	vim.g.bullets_custom_mappings = {
		{ "nmap", "<CR>",      "<Plug>(bullets-newline)" },
		{ "imap", "<CR>",      "<Plug>(bullets-newline)" },
		{ "nmap", "<leader>x", "<Plug>(bullets-toggle-checkbox)" },

		{ "nmap", "<TAB>",     "<Plug>(bullets-demote)" },
		{ "imap", "<TAB>",     "<Plug>(bullets-demote)" },
		{ "vmap", "<TAB>",     "<Plug>(bullets-demote)" },

		{ "nmap", "<S-TAB>",   "<Plug>(bullets-promote)" },
		{ "imap", "<S-TAB>",   "<Plug>(bullets-promote)" },
		{ "vmap", "<S-TAB>",   "<Plug>(bullets-promote)" },
	}
end

function M.setupNvim()
	-- Smart comment deletion: delete empty comment line before inserting newline
	-- Now works since blink-cmp uses <C-y> instead of <CR>
	-- vim.keymap.set('i', '<CR>', function()
	-- 	if is_empty_comment_line() then
	-- 		return '<C-u><CR>'
	-- 	end
	-- 	return '<CR>'
	-- end, { expr = true, desc = "Smart comment deletion" })

	-- Clear highlights and close panels
	map_key(allModes, "<F16>", function()
		hideCodeCompanion()
		vim.cmd("nohlsearch")
		vim.diagnostic.hide()
		vim.cmd("Neotree close")
		vim.cmd("fc") -- close open floating windows like Lazy
		require("sidekick.cli").hide()
	end, { desc = "Clear highlights and close panels" })

	-- Exit terminal mode with Escape
	map_key({ "t" }, "<F16>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
	-- map_key({ "t" }, "<leader><Esc>", "<S-Esc>", { desc = "Send escape key, required in some terminal applications" })

	-- Quick exit
	map_key(allModes, "<leader>qq", ":qa!<CR>", { desc = "Quit all buffers" })

	-- [[ Section: Window Management ]]
	-- Window navigation
	local mode = { "n", "i", "t" }
	map_key(mode, "<C-n>", "<C-w><C-h>", { desc = "Focus left window", escape_insert_terminal = true })
	map_key(mode, "<D-I>", "<C-w><C-l>", { desc = "Focus right window", escape_insert_terminal = true })
	map_key(mode, "<C-e>", "<C-w><C-j>", { desc = "Focus lower window", escape_insert_terminal = true })
	map_key(mode, "<C-u>", "<C-w><C-k>", { desc = "Focus upper window", escape_insert_terminal = true })
	-- Window resizing
	local resizeMultiplier = 10
	local modes = { "n", "i", "t" }
	map_key(modes, "<D-n>", resizeMultiplier .. "<C-w><", { desc = "Decrease window width", stay_in_insert = true })
	map_key(modes, "<D-i>", resizeMultiplier .. "<C-w>>", { desc = "Increase window width", stay_in_insert = true })
	map_key(modes, "<D-e>", resizeMultiplier .. "<C-w>-", { desc = "Decrease window height", stay_in_insert = true })
	map_key(modes, "<D-u>", resizeMultiplier .. "<C-w>+", { desc = "Increase window height", stay_in_insert = true })
	map_key("n", "wh", "<C-w>s", { desc = "Window split Horizontally" })
	map_key("n", "wv", "<C-w>v", { desc = "Window split Vertically" })
	map_key("n", "w/", "<C-w>q", { desc = "Window close" })

	-- ── tab stuff ───────────────────────────────────────────────────────
	map_key("n", "tn", ":tabnew<CR>", { desc = "Tab New" })
	map_key("n", "t/", ":tabclose<CR>", { desc = "Tab Quit" })
	map_key("n", "t.", ":tabn<CR>", { desc = "Tab next" })
	map_key("n", "t,", ":tabp<CR>", { desc = "Tab previous" })

	-- [[ Section: Buffer Navigation ]]
	-- Buffer switching
	map_key({ "n", "i" }, "<C-.>", ":bnext<CR>", { desc = "Next buffer" })
	map_key({ "n", "i" }, "<C-,>", ":bprevious<CR>", { desc = "Previous buffer" })

	-- [[ Section: File Explorer and Projects ]]

	map_key({ "n" }, "<leader>e", ":Neotree filesystem focus left<CR>", { desc = "Open file explorer" })
	map_key({ "n" }, "<leader>sp", ":SessionSearch<CR>", { desc = "Search Projects" })

	-- [[ Section: Snacks Integration ]]

	local picker = require("snacks").picker
	local defaultPickerConfig = {
		follow = true,
		hidden = true,
	}
	map_key("n", "sf", function() picker.files(defaultPickerConfig) end, { desc = "Search Files" })
	map_key("n", "sg", function() picker.grep(defaultPickerConfig) end, { desc = "Search by Grep" })
	map_key("n", "sw", picker.grep_word, { desc = "Search current Word" })
	map_key("n", "s.", picker.recent, { desc = 'Search recent files ("." for repeat)' })
	map_key("n", "sh", picker.help, { desc = "Search Help" })
	map_key("n", "sk", picker.keymaps, { desc = "Search Keymaps" })
	map_key("n", "sd", picker.diagnostics, { desc = "Search Diagnostics" })
	map_key("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Search Diagnostics" })
	map_key("n", "sr", picker.resume, { desc = "Search Resume" })
	map_key("n", "sb", function()
		picker.git_branches({
			layout = {
				preset = "vscode"
			}
		})
	end, { desc = "Search Branches" })
	map_key("n", "ss", Snacks.picker.spelling, { desc = "Search Spell" })
	map_key("n", "sn", picker.notifications, { desc = "Search notify" })
	map_key({ "n" }, "sc", picker.commands, { desc = "Search Commands" })

	-- [[ Section: LSP Integration ]]

	map_key("n", "<leader>cd", vim.diagnostic.setloclist, { desc = "Code Diagnostic list" })

	-- [[ Section: Plugin-specific ]]

	map_key({ "n" }, "<leader>rf", ":luafile %<CR>", { desc = "Reload File" })

	map_key({ "n" }, "<leader>rs", function()
		require("luasnip").cleanup()
		vim.cmd("luafile %")
		require("config.snippets.mySnippets").setup()
		vim.notify("Reloaded Snippets")
	end, { desc = "Reload Snippets" })

	map_key({ "n" }, "<leader>rk", function()
		vim.cmd("luafile %")
		local keymaps = require("keymaps")
		keymaps.setup()
		keymaps.setupNvim()
		vim.notify("Reloaded Keymaps")
	end, { desc = "Reload Keymaps" })

	map_key({ "n" }, "<leader>ot", ":terminal<CR>", { desc = "Open Terminal" })
	map_key({ "n" }, "<leader>oc", function()
		vim.fn.system("code " .. vim.fn.getcwd())
	end, { desc = "Open project in vsCode" })

	map_key({ "n" }, "<leader>ox", openXCodeProject, { desc = "Open project in Xcode" })
	map_key({ "n" }, "<leader>oa", openAndroidStudioProject, { desc = "Open project in Android studio" })

	-- TODO: Extract this along with neo-tree since they're pretty similar
	map_key({ "n" }, "<leader>od", function()
		file_dir = vim.fn.expand("%:h")
		vim.fn.system("open " .. file_dir)
	end, { desc = "Open Directory of the current file" })

	map_key({ "n" }, "<leader>pd", function()
		file_dir = vim.fn.expand("%:p:h")
		vim.fn.setreg("+", file_dir)
		vim.notify("Copied: " .. file_dir)
	end, { desc = "copy absolute file Path Directory" })

	map_key({ "n" }, "<leader>pr", function()
		file_dir = vim.fn.expand("%:~:.")
		vim.fn.setreg("+", file_dir)
		vim.notify("Copied: " .. file_dir)
	end, { desc = "copy Path Relative to the selected file" })

	map_key({ "n" }, "<leader>pp", function()
		local cwd = vim.fn.getcwd()
		vim.fn.setreg("+", cwd)
		vim.notify("Copied: " .. cwd)
	end, { desc = "copy Path to project directory" })

	map_key({ "n" }, "<leader>pa", function()
		local file_path = vim.fn.expand("%:p")
		vim.fn.setreg("+", file_path)
		vim.notify("Copied: " .. file_path)
	end, { desc = "copy Path Absolute to file" })

	-- [[ Section: Insert mode text editing ]]
	map_key({ "i" }, "<D-l>", "<Home>", { desc = "" })
	map_key({ "i" }, "<D-y>", "<End>", { desc = "" })

	-- support for option + backspace & delete
	map_key("i", "<M-Del>", "<C-o>dw", { desc = "" })

	-- support for option + arrows to move words
	map_key("i", "<M-f>", "<C-right>", { desc = "" })
	map_key("i", "<M-b>", "<C-left>", { desc = "" })

	-- Back & worth in jumplist
	map_key(allModes, "<C-,>", "<C-o>", { desc = "Go back" })
	map_key(allModes, "<C-.>", "<C-i>", { desc = "Go back" })

	map_key(allModes, "<F17>", ":OverseerRun<CR>", { desc = "Run Overseer" })

	map_key({ "n" }, "<leader>wn", ":wincmd p<CR>", { desc = "Window go to Next window - switches back & forth" })

	map_key({ "n", "i" }, "<M-Up>", ":m .-2<CR>==", { desc = "move line up" })
	map_key({ "n", "i" }, "<M-Down>", ":m .+1<CR>==", { desc = "move line down" })

	map_key("t", "<D-k>", "<C-l>", { desc = "Clear terminal text" })
	map_key("n", "<leader>or", ":OverseerRun<CR>", { desc = "Overseer Run" })
	map_key("n", "<leader>op", ":OverseerToggle<CR>", { desc = "Overseer Pannel" })

	map_key("n", "<D-d>", "<Cmd>co.<Cr>", { desc = "Dublicate line at cursor" })

	map_key(allModes, "<D-a>", "<Esc>ggVG", { desc = "Select all text" })

	map_key({ "n", "v" }, "<Leader>cb", "<Cmd>CBccbox<CR>", { desc = "Code Box" })
	map_key({ "n", "v" }, "<Leader>ct", "<Cmd>CBllline<CR>", { desc = "Code Table" })
	-- Simple line
	map_key("n", "<Leader>cl", "<Cmd>CBline<CR>", { desc = "Code Line" })
	-- Marked comments
	map_key({ "n", "v" }, "<Leader>cm", "<Cmd>CBllbox14<CR>", { desc = "Code Marked comments" })

	-- ── DiffView stuff ─────────────────────────────────────────────────
	map_key({ "n" }, "<leader>dv", ":DiffviewFileHistory<CR>", { desc = "DiffView file history" })
	map_key({ "n" }, "<leader>df", ":DiffviewFileHistory %<CR>", { desc = "Diffview File history" })
	map_key({ "n" }, "<leader>dc", ":DiffviewOpen<CR>", { desc = "Diff local Changes" })

	-- ── Git stuff ───────────────────────────────────────────────────────
	local gs = require("gitsigns")
	map_key({ "n", "v" }, "<leader>fD", function() vim.lsp.buf.format({ async = true }) end,
		{ desc = "Formate full Document" })

	map_key({ "n", "v" }, "<leader>fd", function()
			for _, hunk in ipairs(gs.get_hunks() or {}) do
				vim.lsp.buf.format({
					range = {
						start = { hunk.added.start, 0 },
						["end"] = { hunk.added.start + hunk.added.count, 0 }
					}
				})
			end
		end,
		{ desc = "Formate full Document" })
end
function M.setupVScode()
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
end

function M.setupLsp(event)
	-- NOTE: Remember that Lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local map = function(keys, func, desc, mode)
		mode = mode or "n"
		vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
	end

	-- Jump to the definition of the word under your cursor.
	--  This is where a variable was first declared, or where a function is defined, etc.
	--  To jump back, press <C-t>.
	local picker = require("snacks").picker
	map("gd", picker.lsp_definitions, "Goto Definition")
	map("ge", function()
		vim.diagnostic.open_float()
		vim.cmd('wincmd w')
	end, "Goto Errors")

	-- Find references for the word under your cursor.
	map("gr", picker.lsp_references, "Goto References")

	-- Jump to the implementation of the word under your cursor.
	--  Useful when your language has ways of declaring types without an actual implementation.
	map("gI", picker.lsp_implementations, "Goto Implementation")

	-- Jump to the type of the word under your cursor.
	--  Useful when you're not sure what type a variable is and you want to see
	--  the definition of its *type*, not where it was *defined*.
	map("<leader>D", picker.lsp_type_definitions, "Type Definition")

	-- Fuzzy find all the symbols in your current document.
	--  Symbols are things like variables, functions, types, etc.
	map("<leader>ds", picker.lsp_symbols, "Document Symbols")

	-- Fuzzy find all the symbols in your current workspace.
	--  Similar to document symbols, except searches over your entire project.
	map("<leader>ws", picker.lsp_workspace_symbols, "Workspace Symbols")

	-- Rename the variable under your cursor.
	--  Most Language Servers support renaming across files, etc.
	map("<leader>rn", vim.lsp.buf.rename, "Rename")

	-- Execute a code action, usually your cursor needs to be on top of an error
	-- or a suggestion from your LSP for this to activate.
	map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

	-- WARN: This is not Goto Definition, this is Goto Declaration.
	--  For example, in C this would take you to the header.
	map("gD", vim.lsp.buf.declaration, "Goto Declaration")

	map("<leader>th", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
	end, "Toggle inlay Hints")
end

return M
