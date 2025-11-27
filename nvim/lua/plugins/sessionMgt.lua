return {
  "rmagatti/auto-session",
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    bypass_session_save_file_types = { "alpha", "dashboard", "gitcommit", "gitrebase", "help" },
    -- log_level = 'debug',

    -- Close sidekick CLI before saving session to avoid Zellij session issues
    pre_save_cmds = {
      function()
        local ok, cli = pcall(require, "sidekick.cli")
        if ok then
          cli.hide()
          cli.close()
          -- Give sidekick time to properly close before saving session
          vim.wait(100)
        end
      end,
    },
  },
}
