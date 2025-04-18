prompt_lib = {
	["Docusaurus"] = {
	  strategy = "chat",
	  description = "Write documentation for me",
	  opts = {
		index = 11,
		is_slash_cmd = false,
		auto_submit = false,
		short_name = "docs",
	  },
	  references = {
		{
		  type = "file",
		  path = {
			"doc/.vitepress/config.mjs",
			"lua/codecompanion/config.lua",
			"README.md",
		  },
		},
	  },
	  prompts = {
		{
		  role = "user",
		  content =
		  [[I'm rewriting the documentation for my plugin CodeCompanion.nvim, as I'm moving to a vitepress website. Can you help me rewrite it?
  
		  I'm sharing my vitepress config file so you have the context of how the documentation website is structured in the `sidebar` section of that file.
  
		  I'm also sharing my `config.lua` file which I'm mapping to the `configuration` section of the sidebar. ]],
		},
	  },
	},
	["Test workflow"] = {
	  strategy = "workflow",
	  description = "Use a workflow to test the plugin",
	  opts = {
		index = 4,
	  },
	  prompts = {
		{
		  {
			role = "user",
			content =
			"Generate a Python class for managing a book library with methods for adding, removing, and searching books",
			opts = {
			  auto_submit = false,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Write unit tests for the library class you just created",
			opts = {
			  auto_submit = true,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Create a TypeScript interface for a complex e-commerce shopping cart system",
			opts = {
			  auto_submit = true,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Write a recursive algorithm to balance a binary search tree in Java",
			opts = {
			  auto_submit = true,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Generate a comprehensive regex pattern to validate email addresses with explanations",
			opts = {
			  auto_submit = true,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Create a Rust struct and implementation for a thread-safe message queue",
			opts = {
			  auto_submit = true,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Write a GitHub Actions workflow file for CI/CD with multiple stages",
			opts = {
			  auto_submit = true,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Create SQL queries for a complex database schema with joins across 4 tables",
			opts = {
			  auto_submit = true,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Write a Lua configuration for Neovim with custom keybindings and plugins",
			opts = {
			  auto_submit = true,
			},
		  },
		},
		{
		  {
			role = "user",
			content = "Generate documentation in JSDoc format for a complex JavaScript API client",
			opts = {
			  auto_submit = true,
			},
		  },
		},
	  },
	},
  }
  
  
  
  adapter_lib = {
	anthropic = function()
	  return require("codecompanion.adapters").extend("anthropic", {
		env = {
		  api_key = os.getenv("ANTHROPIC_API_KEY"),
		},
	  })
	end,
	copilot = function()
	  return require("codecompanion.adapters").extend("copilot", {
		schema = {
		  model = {
			default = "claude-3.7-sonnet",
		  },
		},
	  })
	end,
	deepseek = function()
	  return require("codecompanion.adapters").extend("deepseek", {
		env = {
		  api_key = "cmd:op read op://personal/DeepSeek_API/credential --no-newline",
		},
	  })
	end,
	gemini = function()
	  return require("codecompanion.adapters").extend("gemini", {
		env = {
		  api_key = "cmd:op read op://personal/Gemini_API/credential --no-newline",
		},
	  })
	end,
	ollama = function()
	  return require("codecompanion.ada:TSInstall markdownpters").extend("ollama", {
		schema = {
		  num_ctx = {
			default = 20000,
		  },
		},
	  })
	end,
	openai = function()
	  return require("codecompanion.adapters").extend("openai", {
		env = {
		  api_key = "cmd:op read op://personal/OpenAI_API/credential --no-newline",
		},
		schema = {
		  model = {
			default = function()
			  return "gpt-4o"
			end,
		  },
		},
	  })
	end,
	xai = function()
	  return require("codecompanion.adapters").extend("xai", {
		env = {
		  api_key = "cmd:op read op://personal/xAI_API/credential --no-newline",
		},
	  })
	end,
  }
  