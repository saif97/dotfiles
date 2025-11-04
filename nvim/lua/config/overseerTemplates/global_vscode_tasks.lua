local overseer = require("overseer")
local files = require("overseer.files")
local vscode_template = require("overseer.template.vscode")

-- Path to your global tasks.json
local GLOBAL_TASKS_FILE = vim.fn.expand("~/dotfiles/vscode_configs/tasks.json")

-- Strip JSON comments (lines starting with //)
local function strip_json_comments(json_str)
	local lines = vim.split(json_str, "\n")
	local cleaned = {}
	for _, line in ipairs(lines) do
		-- Remove lines that are just comments
		if not line:match("^%s*//") then
			table.insert(cleaned, line)
		end
	end
	return table.concat(cleaned, "\n")
end

return {
	name = "Global VSCode Tasks",
	condition = {
		callback = function(opts)
			-- Always show global tasks
			return true
		end,
	},
	generator = function(opts, cb)
		if not files.exists(GLOBAL_TASKS_FILE) then
			cb({})
			return
		end

		-- Read file manually to handle comments
		local file = io.open(GLOBAL_TASKS_FILE, "r")
		if not file then
			cb({})
			return
		end
		local json_str = file:read("*all")
		file:close()

		-- Strip comments and parse
		json_str = strip_json_comments(json_str)
		local ok, content = pcall(vim.json.decode, json_str)
		if not ok or not content or not content.tasks then
			cb({})
			return
		end

		local ret = {}
		local precalculated_vars = require("overseer.template.vscode.variables").precalculate_vars()

		for _, task in ipairs(content.tasks) do
			-- Fix command arrays by joining them
			if type(task.command) == "table" then
				task.command = table.concat(task.command, " ")
			end

			local tmpl = vscode_template.convert_vscode_task(task, precalculated_vars)
			if tmpl then
				-- Prefix the name to indicate it's a global task
				tmpl.name = "[Global] " .. tmpl.name
				table.insert(ret, tmpl)
			end
		end

		cb(ret)
	end,
}
