return {
	{
		"nvim-treesitter/nvim-treesitter",
		commit = "4916d6592ede8c07973490d9322f187e07dfefac",
		branch = "main",
		lazy = false,
		build = function() require("nvim-treesitter").update() end,
		config = function()
			require("nvim-treesitter").setup({})

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local ft = vim.bo[ev.buf].filetype
					if ft == "" then return end
					local lang = vim.treesitter.language.get_lang(ft) or ft
					local cfg = require("nvim-treesitter.config")
					if not vim.tbl_contains(cfg.get_installed(), lang)
						and vim.tbl_contains(cfg.get_available(), lang) then
						require("nvim-treesitter").install({ lang })
					end
					pcall(vim.treesitter.start, ev.buf)
					if ft ~= "markdown" then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		commit = "851e865342e5a4cb1ae23d31caf6e991e1c99f1e",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "<c-v>",
					},
					include_surrounding_whitespace = true,
				},
				move = { set_jumps = true },
			})

			local sel = require("nvim-treesitter-textobjects.select")
			local swap = require("nvim-treesitter-textobjects.swap")

			local function pickSel(query, group)
				return function() sel.select_textobject(query, group or "textobjects") end
			end

			vim.keymap.set({ "x", "o" }, "af", pickSel("@function.outer"), { desc = "around function" })
			vim.keymap.set({ "x", "o" }, "of", pickSel("@function.inner"), { desc = "inner function" })
			vim.keymap.set({ "x", "o" }, "ac", pickSel("@class.outer"), { desc = "around class" })
			vim.keymap.set({ "x", "o" }, "oc", pickSel("@class.inner"), { desc = "inner class" })
			vim.keymap.set({ "x", "o" }, "as", pickSel("@local.scope", "locals"), { desc = "around scope" })

			vim.keymap.set("n", "<leader>s]", function() swap.swap_next("@parameter.inner") end, { desc = "swap param next" })
			vim.keymap.set("n", "<leader>s[", function() swap.swap_previous("@parameter.inner") end, { desc = "swap param prev" })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		commit = "1a1a7c5d6d75cb49bf64049dafab15ebe294a79f",
		event = "VeryLazy",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				multiwindow = true,
				max_lines = 0,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = "━",
			})
		end,
	},
}
