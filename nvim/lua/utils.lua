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
