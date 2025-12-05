local function poop()
	local Config = require("sidekick.config")
	local clients = Config.get_clients()
	for _, client in ipairs(clients) do
		vim.notify("Pooping on " .. client.name, vim.log.levels.INFO)
	end
	
end

vim.api.nvim_create_user_command('Poop', function()
	poop()
end, {})

local function restart_lsp(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local clients
	if vim.lsp.get_clients then
		clients = vim.lsp.get_clients({ bufnr = bufnr })
	else
		---@diagnostic disable-next-line: deprecated
		clients = vim.lsp.get_active_clients({ bufnr = bufnr })
	end

	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id)
	end

	vim.defer_fn(function()
		vim.cmd('edit')
	end, 100)
end

vim.api.nvim_create_user_command('LspRestart', function()
	restart_lsp()
end, {})

local function lsp_status()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr }) or
			vim.lsp.get_active_clients({ bufnr = bufnr })

	if #clients == 0 then
		print("󰅚 No LSP clients attached")
		return
	end

	print("󰒋 LSP Status for buffer " .. bufnr .. ":")
	print("─────────────────────────────────")

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
		print("  Root: " .. (client.config.root_dir or "N/A"))
		print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

		-- Check capabilities
		local caps = client.server_capabilities
		local features = {}
		if caps.completionProvider then table.insert(features, "completion") end
		if caps.hoverProvider then table.insert(features, "hover") end
		if caps.definitionProvider then table.insert(features, "definition") end
		if caps.referencesProvider then table.insert(features, "references") end
		if caps.renameProvider then table.insert(features, "rename") end
		if caps.codeActionProvider then table.insert(features, "code_action") end
		if caps.documentFormattingProvider then table.insert(features, "formatting") end

		print("  Features: " .. table.concat(features, ", "))
		print("")
	end
end

vim.api.nvim_create_user_command('LspStatus', lsp_status, { desc = "Show detailed LSP status" })

local function check_lsp_capabilities()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr }) or
			vim.lsp.get_active_clients({ bufnr = bufnr })

	if #clients == 0 then
		print("No LSP clients attached")
		return
	end

	for _, client in ipairs(clients) do
		print("Capabilities for " .. client.name .. ":")
		local caps = client.server_capabilities

		local capability_list = {
			{ "Completion",                caps.completionProvider },
			{ "Hover",                     caps.hoverProvider },
			{ "Signature Help",            caps.signatureHelpProvider },
			{ "Go to Definition",          caps.definitionProvider },
			{ "Go to Declaration",         caps.declarationProvider },
			{ "Go to Implementation",      caps.implementationProvider },
			{ "Go to Type Definition",     caps.typeDefinitionProvider },
			{ "Find References",           caps.referencesProvider },
			{ "Document Highlight",        caps.documentHighlightProvider },
			{ "Document Symbol",           caps.documentSymbolProvider },
			{ "Workspace Symbol",          caps.workspaceSymbolProvider },
			{ "Code Action",               caps.codeActionProvider },
			{ "Code Lens",                 caps.codeLensProvider },
			{ "Document Formatting",       caps.documentFormattingProvider },
			{ "Document Range Formatting", caps.documentRangeFormattingProvider },
			{ "Rename",                    caps.renameProvider },
			{ "Folding Range",             caps.foldingRangeProvider },
			{ "Selection Range",           caps.selectionRangeProvider },
		}

		for _, cap in ipairs(capability_list) do
			local status = cap[2] and "✓" or "✗"
			print(string.format("  %s %s", status, cap[1]))
		end
		print("")
	end
end

vim.api.nvim_create_user_command('LspCapabilities', check_lsp_capabilities, { desc = "Show LSP capabilities" })

local function lsp_diagnostics_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)

	local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

	for _, diagnostic in ipairs(diagnostics) do
		local severity = vim.diagnostic.severity[diagnostic.severity]
		counts[severity] = counts[severity] + 1
	end

	print("󰒡 Diagnostics for current buffer:")
	print("  Errors: " .. counts.ERROR)
	print("  Warnings: " .. counts.WARN)
	print("  Info: " .. counts.INFO)
	print("  Hints: " .. counts.HINT)
	print("  Total: " .. #diagnostics)
end

vim.api.nvim_create_user_command('LspDiagnostics', lsp_diagnostics_info, { desc = "Show LSP diagnostics count" })


local function lsp_info()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr }) or
			vim.lsp.get_active_clients({ bufnr = bufnr })

	print("═══════════════════════════════════")
	print("           LSP INFORMATION          ")
	print("═══════════════════════════════════")
	print("")

	-- Basic info
	print("󰈙 Language client log: " .. vim.lsp.get_log_path())
	print("󰈔 Detected filetype: " .. vim.bo.filetype)
	print("󰈮 Buffer: " .. bufnr)
	print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
	print("")

	if #clients == 0 then
		print("󰅚 No LSP clients attached to buffer " .. bufnr)
		print("")
		print("Possible reasons:")
		print("  • No language server installed for " .. vim.bo.filetype)
		print("  • Language server not configured")
		print("  • Not in a project root directory")
		print("  • File type not recognized")
		return
	end

	print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
	print("─────────────────────────────────")

	for i, client in ipairs(clients) do
		print(string.format("󰌘 Client %d: %s", i, client.name))
		print("  ID: " .. client.id)
		print("  Root dir: " .. (client.config.root_dir or "Not set"))
		local cmd = client.config.cmd
		if type(cmd) == "table" then
			print("  Command: " .. table.concat(cmd, " "))
		else
			print("  Command: " .. (cmd or "Not set"))
		end
		local filetypes = client.config.filetypes
		if type(filetypes) == "table" then
			print("  Filetypes: " .. table.concat(filetypes, ", "))
		else
			print("  Filetypes: " .. (filetypes or "Not set"))
		end

		-- Server status
		if client.is_stopped then
			print("  Status: 󰅚 Stopped")
		else
			print("  Status: 󰄬 Running")
		end

		-- Workspace folders
		if client.workspace_folders and #client.workspace_folders > 0 then
			print("  Workspace folders:")
			for _, folder in ipairs(client.workspace_folders) do
				print("    • " .. folder.name)
			end
		end

		-- Attached buffers count
		local attached_buffers = {}
		for buf, _ in pairs(client.attached_buffers or {}) do
			table.insert(attached_buffers, buf)
		end
		print("  Attached buffers: " .. #attached_buffers)

		-- Key capabilities
		local caps = client.server_capabilities
		local key_features = {}
		if caps.completionProvider then table.insert(key_features, "completion") end
		if caps.hoverProvider then table.insert(key_features, "hover") end
		if caps.definitionProvider then table.insert(key_features, "definition") end
		if caps.documentFormattingProvider then table.insert(key_features, "formatting") end
		if caps.codeActionProvider then table.insert(key_features, "code_action") end

		if #key_features > 0 then
			print("  Key features: " .. table.concat(key_features, ", "))
		end

		print("")
	end

	-- Diagnostics summary
	local diagnostics = vim.diagnostic.get(bufnr)
	if #diagnostics > 0 then
		print("󰒡 Diagnostics Summary:")
		local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

		for _, diagnostic in ipairs(diagnostics) do
			local severity = vim.diagnostic.severity[diagnostic.severity]
			counts[severity] = counts[severity] + 1
		end

		print("  󰅚 Errors: " .. counts.ERROR)
		print("  󰀪 Warnings: " .. counts.WARN)
		print("  󰋽 Info: " .. counts.INFO)
		print("  󰌶 Hints: " .. counts.HINT)
		print("  Total: " .. #diagnostics)
	else
		print("󰄬 No diagnostics")
	end

	print("")
	print("Use :LspLog to view detailed logs")
	print("Use :LspCapabilities for full capability list")
end

-- Create command
vim.api.nvim_create_user_command('LspInfo', lsp_info, { desc = "Show comprehensive LSP information" })


local function lsp_status_short()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = bufnr }) or
			vim.lsp.get_active_clients({ bufnr = bufnr })

	if #clients == 0 then
		return "" -- Return empty string when no LSP
	end

	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end

	return "󰒋 " .. table.concat(names, ",")
end

local function git_branch()
	local ok, handle = pcall(io.popen, "git branch --show-current 2>/dev/null")
	if not ok or not handle then
		return ""
	end
	local branch = handle:read("*a")
	handle:close()
	if branch and branch ~= "" then
		branch = branch:gsub("\n", "")
		return "󰊢 " .. branch
	end
	return ""
end
-- Safe wrapper functions for statusline
local function safe_git_branch()
	local ok, result = pcall(git_branch)
	return ok and result or ""
end

local function safe_lsp_status()
	local ok, result = pcall(lsp_status_short)
	return ok and result or ""
end

_G.git_branch = safe_git_branch
_G.lsp_status = safe_lsp_status

-- THEN set the statusline
vim.opt.statusline = table.concat({
	"%{v:lua.git_branch()}", -- Git branch
	"%f",                   -- File name
	"%m",                   -- Modified flag
	"%r",                   -- Readonly flag
	"%=",                   -- Right align
	"%{v:lua.lsp_status()}", -- LSP status
	" %l:%c",               -- Line:Column
	" %p%%"                 -- Percentage through file
}, " ")

-- DevContainer scaffolding
local function devcontainer_init()
	local cwd = vim.fn.getcwd()
	local devcontainer_dir = cwd .. "/.devcontainer"
	local devcontainer_json = devcontainer_dir .. "/devcontainer.json"
	local dockerfile_shim = devcontainer_dir .. "/Dockerfile"
	local template_path = vim.fn.expand("~/dotfiles/devContainer/template/devcontainer.json")
	local dockerfile_template_path = vim.fn.expand("~/dotfiles/devContainer/template/Dockerfile")

	-- Check if templates exist
	if vim.fn.filereadable(template_path) == 0 then
		vim.notify("Template not found: " .. template_path, vim.log.levels.ERROR)
		return
	end
	if vim.fn.filereadable(dockerfile_template_path) == 0 then
		vim.notify("Dockerfile template not found: " .. dockerfile_template_path, vim.log.levels.ERROR)
		return
	end

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

vim.api.nvim_create_user_command('DevContainerInit', devcontainer_init, { desc = "Scaffold .devcontainer directory" })
