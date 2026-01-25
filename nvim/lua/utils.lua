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
		"example/ios/*.xcworkspace",
		"example/ios/*.xcodeproj",
		"demo-app/platforms/ios/*.xcworkspace",
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
		"example/android/build.gradle*",
		"example/android/settings.gradle*",
		"android/build.gradle*",
		"android/settings.gradle*",
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

-- ── Git & URL helpers ───────────────────────────────────────────────

-- Get git remote URL and convert to web URL
local function getGitRemoteUrl(remote_name)
	remote_name = remote_name or "origin"
	local remote_url = vim.fn.system("git config --get remote." .. remote_name .. ".url"):gsub("%s+", "")

	if remote_url == "" or vim.v.shell_error ~= 0 then
		vim.notify("No " .. remote_name .. " remote found", vim.log.levels.WARN)
		return nil
	end

	-- Convert SSH URL to HTTPS
	-- git@github.com:user/repo.git -> https://github.com/user/repo
	remote_url = remote_url:gsub("git@([^:]+):(.+)%.git", "https://%1/%2")
	remote_url = remote_url:gsub("git@([^:]+):(.+)", "https://%1/%2")
	-- Also handle https URLs that end with .git
	remote_url = remote_url:gsub("%.git$", "")

	return remote_url
end

-- Open URL in browser
local function openUrl(url)
	if not url then return end
	vim.fn.system("open " .. vim.fn.shellescape(url))
	vim.notify("Opening: " .. url)
end

-- Open git remote in browser
function openGitRemote()
	local url = getGitRemoteUrl("origin")
	openUrl(url)
end

-- Open git upstream in browser
function openGitUpstream()
	local url = getGitRemoteUrl("upstream")
	openUrl(url)
end

-- Open current git branch in browser
function openGitBranch()
	local branch = vim.fn.system("git branch --show-current"):gsub("%s+", "")
	if branch == "" or vim.v.shell_error ~= 0 then
		vim.notify("Not on a git branch", vim.log.levels.WARN)
		return
	end

	local base_url = getGitRemoteUrl("origin")
	if base_url then
		local url = base_url .. "/tree/" .. branch
		openUrl(url)
	end
end

-- Open Jira ticket extracted from current git branch
function openJiraTicket()
	local branch = vim.fn.system("git branch --show-current"):gsub("%s+", "")
	if branch == "" or vim.v.shell_error ~= 0 then
		vim.notify("Not on a git branch", vim.log.levels.WARN)
		return
	end

	-- Extract ticket ID (pattern: ABC-123)
	local ticket = branch:match("([A-Za-z]+%-?%d+)")
	if not ticket then
		vim.notify("No ticket ID found in branch: " .. branch, vim.log.levels.WARN)
		return
	end

	local jira_url = os.getenv("JIRA_URL")
	if not jira_url then
		vim.notify("JIRA_URL environment variable not set", vim.log.levels.ERROR)
		return
	end

	-- Remove trailing slash if present
	jira_url = jira_url:gsub("/$", "")
	local url = jira_url .. "/browse/" .. ticket:upper()
	openUrl(url)
end
