local M = {}

-- Get the path to the templates directory
local function get_template_dir()
	local source = debug.getinfo(1, "S").source:sub(2)
	return vim.fn.fnamemodify(source, ":h") .. "/config/templates"
end

-- DevContainer scaffolding
local function devcontainer_init()
	local cwd = vim.fn.getcwd()
	local devcontainer_dir = cwd .. "/.devcontainer"
	local devcontainer_json = devcontainer_dir .. "/devcontainer.json"
	local dockerfile_shim = devcontainer_dir .. "/Dockerfile"

	local template_dir = get_template_dir() .. "/devContainer"
	local template_path = template_dir .. "/devcontainer.json"
	local dockerfile_template_path = template_dir .. "/Dockerfile"

	-- Check if .devcontainer already exists
	if vim.fn.isdirectory(devcontainer_dir) == 1 then
		vim.notify(".devcontainer/ already exists", vim.log.levels.WARN)
		return
	end

	-- Create directory
	vim.fn.mkdir(devcontainer_dir, "p")

	-- 1. Process and write devcontainer.json
	local lines = vim.fn.readfile(template_path)
	local content = table.concat(lines, "\n")

	-- Replace <project-name> with current directory name
	local project_name = vim.fn.fnamemodify(cwd, ":t")
	content = content:gsub("<project%-name>", project_name)

	local file = io.open(devcontainer_json, "w")
	if file then
		file:write(content)
		file:close()
	else
		vim.notify("Failed to write devcontainer.json", vim.log.levels.ERROR)
		return
	end

	-- 2. Copy Dockerfile shim
	local dock_lines = vim.fn.readfile(dockerfile_template_path)
	local dock_content = table.concat(dock_lines, "\n")

	local dock_file = io.open(dockerfile_shim, "w")
	if dock_file then
		dock_file:write(dock_content)
		dock_file:close()
	else
		vim.notify("Failed to write Dockerfile", vim.log.levels.ERROR)
		return
	end

	vim.notify("Created .devcontainer/ with devcontainer.json and Dockerfile", vim.log.levels.INFO)
	vim.cmd("edit " .. devcontainer_json)
end

-- Justfile scaffolding
local function justfile_init()
	local cwd = vim.fn.getcwd()
	local justfile_path = cwd .. "/.justfile"
	local template_path = get_template_dir() .. "/justfile"

	if vim.fn.filereadable(justfile_path) == 1 then
		vim.notify(".justfile already exists", vim.log.levels.WARN)
		return
	end

	local lines = vim.fn.readfile(template_path)
	local content = table.concat(lines, "\n")

	local file = io.open(justfile_path, "w")
	if file then
		file:write(content)
		file:close()
	else
		vim.notify("Failed to write .justfile", vim.log.levels.ERROR)
		return
	end

	vim.notify("Created .justfile", vim.log.levels.INFO)
	vim.cmd("edit " .. justfile_path)
end

-- Gemini scaffolding
local function gemini_init()
	local cwd = vim.fn.getcwd()
	local gemini_dir = cwd .. "/.gemini"
	local settings_path = gemini_dir .. "/settings.json"
	local template_path = get_template_dir() .. "/gemini/settings.json"

	-- Check if .gemini already exists
	if vim.fn.isdirectory(gemini_dir) == 1 then
		vim.notify(".gemini/ already exists", vim.log.levels.WARN)
		return
	end

	-- Create directory
	vim.fn.mkdir(gemini_dir, "p")

	local lines = vim.fn.readfile(template_path)
	local content = table.concat(lines, "\n")

	local file = io.open(settings_path, "w")
	if file then
		file:write(content)
		file:close()
	else
		vim.notify("Failed to write .gemini/settings.json", vim.log.levels.ERROR)
		return
	end

	vim.notify("Created .gemini/settings.json", vim.log.levels.INFO)
	vim.cmd("edit " .. settings_path)
end

function M.setup()
	vim.api.nvim_create_user_command('InitDevContainer', devcontainer_init, { desc = "Scaffold .devcontainer directory" })
	vim.api.nvim_create_user_command('InitJustfile', justfile_init, { desc = "Scaffold .justfile" })
	vim.api.nvim_create_user_command('InitGemini', gemini_init, { desc = "Scaffold .gemini directory" })
end

return M
