return {
  'rmagatti/auto-session',
  config = function()
    require("auto-session").setup {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
    }
    vim.o.sessionoptions="buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end
}
