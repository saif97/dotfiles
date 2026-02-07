-- Sync clipboard between OS and Neovim.
-- Uses OSC 52 escape sequences for SSH clipboard support.
-- See `:help 'clipboard'` and `:help clipboard-osc52`
vim.g.clipboard = {
	name = 'OSC 52',
	copy = {
		['+'] = require('vim.ui.clipboard.osc52').copy('+'),
		['*'] = require('vim.ui.clipboard.osc52').copy('*'),
	},
	paste = {
		['+'] = vim.env.SSH_TTY
			and require('vim.ui.clipboard.osc52').paste('+')
			or { 'pbpaste' },
		['*'] = vim.env.SSH_TTY
			and require('vim.ui.clipboard.osc52').paste('*')
			or { 'pbpaste' },
	},
}
vim.opt.clipboard = 'unnamedplus'

vim.cmd("let $NVIM_LOG_FILE='/tmp/nvim.log'")
-- Set the log level to debug

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if vim.g.vscode then
	-- to fix https://github.com/vscode-neovim/vscode-neovim/issues/1137#issuecomment-1936954633
	vim.keymap.set("", "<Space>", "<Nop>")
else -- Neovim-only configurations
	vim.cmd("set backspace=indent,eol,start")

	vim.cmd("set autoindent")

	vim.opt.autowriteall = true
	vim.opt.wrap = false

	-- Make line numbers default
	vim.opt.number = true

	-- Enable mouse mode, can be useful for resizing splits for example!
	vim.opt.mouse = "a"

	-- Don't show the mode, since it's already in the status line
	vim.opt.showmode = false

	-- Save undo history
	vim.opt.undofile = true

	-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
	vim.opt.ignorecase = true
	vim.opt.smartcase = true

	-- Keep signcolumn on by default
	vim.opt.signcolumn = "yes"

	-- Decrease update time
	vim.opt.updatetime = 250

	-- Decrease mapped sequence wait time
	vim.opt.timeoutlen = 300

	-- Configure how new splits should be opened
	vim.opt.splitright = true
	vim.opt.splitbelow = true

	-- Sets how neovim will display certain whitespace characters in the editor.
	--  See `:help 'list'`
	--  and `:help 'listchars'`
	vim.opt.list = true
	vim.opt.listchars = {
		tab = "→ ",
		trail = "•",
		nbsp = "␣",
		extends = "▶",
		precedes = "◀"
	}

	local tabSize = 2
	vim.opt.tabstop = tabSize
	vim.opt.shiftwidth = tabSize
	vim.opt.expandtab = false

	-- Preview substitutions live, as you type!
	vim.opt.inccommand = "split"

	-- Show which line your cursor is on
	vim.opt.cursorline = true

	-- Minimal number of screen lines to keep above and below the cursor.
	vim.opt.scrolloff = 10

	-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
	-- instead raise a dialog asking if you wish to save the current file(s)
	-- See `:help 'confirm'`
	vim.opt.confirm = true

	-- [[ Basic Keymaps ]]
	--  See `:help vim.keymap.set()`

	-- Clear highlights on search when pressing <Esc> in normal mode
	--  See `:help hlsearch`
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	-- Diagnostic keymaps
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

	vim.o.mousescroll = "ver:3,hor:0"
	vim.opt.termguicolors = true

	vim.opt.spell = true
	vim.opt.spelllang = "en_us"

	vim.opt.fillchars:append("diff:╱")
	vim.opt.fillchars:append("eob: ")

	-- Show indicator for wrapped lines
	vim.opt.showbreak = "↪ "

	vim.o.termguicolors = true
	vim.o.cursorline = true

	-- Smart comment continuation (VSCode-like)
	-- formatoptions flags:
	--   j: Remove comment leader when joining lines with J
	--   q: Allow formatting of comments with gq
	--   l: Don't break long lines that were already long in insert mode
	--   n: Recognize numbered lists when formatting
	--   r: Auto-insert comment leader after Enter in insert mode
	--   o: Auto-insert comment leader after o/O in normal mode
	-- Excluded: t/c (auto-wrap), a (auto-format paragraphs)
	vim.opt.formatoptions = "jqlnro"

	-- Do not automatically add a newline at end of file
	vim.opt.fixendofline = false

	vim.g.copilot_filetypes = {
		{ "xml", "false" }
	}
end

vim.filetype.add({
	filename = {
		["Fastfile"] = "ruby",
		["Appfile"] = "ruby",
		["Matchfile"] = "ruby"
	},
	pattern = {
		[".*%.justfile"] = "just"
	}
})
