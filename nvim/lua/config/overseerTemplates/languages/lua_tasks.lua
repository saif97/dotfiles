local overseer = require("overseer")
filetype = "lua"

overseer.register_template({
	name = "Say Cheeeessslua ",
	builder = function(params)
		return {
			cmd = { "python" },
			args = { vim.fn.expand("%:p") },
			components = { "default" },
		}
	end,
		condition = {
		filetype = { filetype },
	},
})
