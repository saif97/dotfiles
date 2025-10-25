function map_key(modes, from, to, options)
	local default_options = { noremap = true, silent = false }
	local merged_options = vim.tbl_extend("force", default_options, options or {})

	if type(modes) == "string" then
		modes = { modes }
	end

	for _, mode in ipairs(modes) do
		local prefixed_to = to
		if options.stay_in_insert then
			if mode == "i" then
				prefixed_to = "<C-o>" .. to
			elseif mode == "t" then
				prefixed_to = "<C-\\><C-n>" .. to .. "i"
			end
			merged_options.stay_in_insert = nil
		end
		if options.escape_insert_terminal then
			if mode == "i" then
				prefixed_to = "<Esc>" .. to 
			elseif mode == "t" then
				prefixed_to = "<C-\\><C-n>" .. to 
			end
			merged_options.escape_insert_terminal = nil
		end
		vim.keymap.set(mode, from, prefixed_to, merged_options)
	end
end

if vim.g.vscode then
	local vscode = require("vscode")

	function callVscodeActions(modes, from, actionsList, isAsync, optionsList)
		isAsync = isAsync or true
		optionsList = optionsList or {}
		if type(modes) == "string" then
			modes = { modes }
		end

		if type(actionsList) == "string" then
			actionsList = { actionsList }
		end

		for _, mode in ipairs(modes) do
			vim.keymap.set(mode, from, function()
				for i, actionName in ipairs(actionsList) do
					if isAsync then
						vscode.action(actionName, optionsList[i] or {})
					else
						vscode.call(actionName, optionsList[i] or {})
					end
				end
			end, {})
		end
	end
else
	-- Neovim-only configurations
end

function hideCodeCompanion()
	pcall(function()
		local cc = require("codecompanion")
		local chat = cc.buf_get_chat(vim.api.nvim_get_current_buf())
		if chat then
			vim.cmd("wincmd p")
		end

		local chat = cc.last_chat()
		if chat and chat.ui:is_visible() then
			chat.ui:hide()
		end
	end)
end

function isPersonalMachine()
	return os.getenv("IS_PERSONAL_MACHINE") ~= nil
end

-- Check if current line is an empty comment (only whitespace + comment marker)
function is_empty_comment_line()
	local line = vim.api.nvim_get_current_line()
	return line:match('^%s*///?%s*$') or   -- C-style and doc comments
	       line:match('^%s*#%s*$') or      -- Shell/Python
	       line:match('^%s*%-%-%s*$') or   -- Lua
	       line:match('^%s*";%s*$')        -- Clojure
end

function openXCodeProject()
	local cwd = vim.fn.getcwd()
	-- Search order: workspace files first (preferred), then project files
	-- Check common framework locations: ios/, macos/, root
	local search_patterns = {
		"ios/*.xcworkspace",
		"ios/*.xcodeproj",
		"macos/*.xcworkspace",
		"macos/*.xcodeproj",
		"example/*.xcworkspace",
		"example/*.xcodeproj",
		"*.xcworkspace",
		"*.xcodeproj",
	}
	for _, pattern in ipairs(search_patterns) do
		local matches = vim.fn.glob(cwd .. "/" .. pattern, false, true)
		if #matches > 0 then
			-- Use the first match found
			vim.fn.system("open " .. vim.fn.shellescape(matches[1]))
			vim.notify("Opening: " .. vim.fn.fnamemodify(matches[1], ":t"))
			return
		end
	end

	vim.notify("No Xcode project found", vim.log.levels.WARN)
end

function openAndroidStudioProject()
	local cwd = vim.fn.getcwd()
	-- Search for Android project directories (look for gradle files)
	-- Check common framework locations: android/, example/android/, root
	local search_paths = {
		"android/build.gradle*",
		"android/settings.gradle*",
		"example/android/build.gradle*",
		"example/android/settings.gradle*",
		"build.gradle*",
		"settings.gradle*",
	}

	for _, pattern in ipairs(search_paths) do
		local matches = vim.fn.glob(cwd .. "/" .. pattern, false, true)
		if #matches > 0 then
			-- Get the directory containing the gradle file
			local project_dir = vim.fn.fnamemodify(matches[1], ":h")
			vim.fn.system("open -a 'Android Studio' " .. vim.fn.shellescape(project_dir))
			vim.notify("Opening: " .. vim.fn.fnamemodify(project_dir, ":t"))
			return
		end
	end

	vim.notify("No Android project found", vim.log.levels.WARN)
end
