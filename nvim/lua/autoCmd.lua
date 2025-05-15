vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

if vim.g.vscode then
	-- VSCode-specific configurations
else
	vim.api.nvim_create_autocmd("TermOpen", {
		group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
		callback = function()
			vim.opt.number = false
			vim.opt.relativenumber = false
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "Avante*" },
		callback = function()
			vim.api.nvim_win_set_option(0, "winfixwidth", false)
			vim.api.nvim_win_set_option(0, "winfixheight", true)
		end,
	})
	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "*",
		callback = function()
			vim.wo.spell = false
		end,
	})
end
