local overseer = require("overseer")
filetype = "python"

overseer.register_template({
	name = "Run Python Script",
	builder = function(params)
		return {
			cmd = { "python" },
			args = { vim.fn.expand("%:p") },
			components = { "default" },
		}
	end,
	condition = {
		filetype = { "python" }, -- This task will only appear for Python files
	},
})
overseer.register_template({
	name = "Python: Create pyrightConfig.json file",
	builder = function(params)
		return {
			cmd = { "touch", "pyrightconfig.json" },
			components = { "default" },
		}
	end,
	condition = {
		filetype = { "python" }, -- This task will also only appear for Python files
	},
})
