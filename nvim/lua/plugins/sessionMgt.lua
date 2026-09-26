return {
  "rmagatti/auto-session",
  commit = "00334ee24b9a05001ad50221c8daffbeedaa0842",
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    bypass_session_save_file_types = { "alpha", "dashboard", "gitcommit", "gitrebase", "help" },
    -- log_level = 'debug',
  },
}
