local overseer = require("overseer")

-- Helper to get flutter command (respects fvm if configured)
local function get_flutter_cmd()
	local flutter_config = require('flutter-tools.config')
	if flutter_config.flutter_path then
		-- Expand environment variables like $HOME
		return vim.fn.expand(flutter_config.flutter_path)
	end
	return "flutter"
end

-- Flutter Run (Development)
overseer.register_template({
	name = "Flutter: Run (Debug)",
	builder = function(params)
		return {
			cmd = { get_flutter_cmd() },
			args = { "run" },
			components = {
				"default",
			},
		}
	end,
	condition = {
		filetype = { "dart" },
	},
})

-- Flutter Run (Release)
overseer.register_template({
	name = "Flutter: Run (Release)",
	builder = function(params)
		return {
			cmd = { get_flutter_cmd() },
			args = { "run", "--release" },
			components = { "default" },
		}
	end,
	condition = {
		filetype = { "dart" },
	},
})

-- Flutter Test (All)
overseer.register_template({
	name = "Flutter: Test All",
	builder = function(params)
		return {
			cmd = { get_flutter_cmd() },
			args = { "test" },
			components = {
				{ "on_output_quickfix", open = true },
				"default",
			},
		}
	end,
	condition = {
		filetype = { "dart" },
	},
})

-- Flutter Clean
overseer.register_template({
	name = "Flutter: Clean",
	builder = function(params)
		return {
			cmd = { get_flutter_cmd() },
			args = { "clean" },
			components = { "default" },
		}
	end,
	condition = {
		filetype = { "dart" },
	},
})
