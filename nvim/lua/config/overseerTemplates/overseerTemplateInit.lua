M = {}
function M.setup()
	require("config.overseerTemplates.languages.lua_tasks")
	require("config.overseerTemplates.languages.python_tasks")
	require("config.overseerTemplates.languages.flutter_tasks")

	-- Register global vscode tasks template
	local overseer = require("overseer")
	overseer.register_template(require("config.overseerTemplates.global_vscode_tasks"))
end

return M
