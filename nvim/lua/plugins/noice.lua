-- lazyzy.nvim
return {
	"folke/noice.nvim",
	commit = "7bfd942445fb63089b59f97ca487d605e715f155",
	event = "VeryLazy",
	opts = {
		lsp = {
			-- override markdown rendering so that LSP docs use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = true,       -- use a classic bottom cmdline for search
			command_palette = true,     -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false,         -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = true,      -- add a border to hover docs and signature help
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
	}
}
