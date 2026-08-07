vim.api.nvim_create_user_command("Gitsigns blame", "Gitsigns blame", { desc = "Show git blame for the current line" })

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			current_line_blame = true,
			preview_config = {
				border = "rounded",
			},

			on_attach = function(bufnr)
				local gitsigns = require('gitsigns')

				-- Buffer-local so these only apply where gitsigns attached
				local function map(mode, lhs, rhs, opts)
					opts = vim.tbl_extend("force", { buffer = bufnr }, opts or {})
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				-- Navigation
				map('n', 'I', function()
					if vim.wo.diff then
						vim.cmd.normal({ ']c', bang = true })
					else
						gitsigns.nav_hunk('next')
					end
				end)

				map('n', 'N', function()
					if vim.wo.diff then
						vim.cmd.normal({ '[c', bang = true })
					else
						gitsigns.nav_hunk('prev')
					end
				end)
			end
		})
	end,
}
