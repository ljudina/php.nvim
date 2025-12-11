return {
  "justinmk/vim-sneak",
  event = "VeryLazy",
  config = function()
    vim.g["sneak#label"] = 1        -- show labels for targets
    vim.g["sneak#use_ic_scs"] = 1   -- smartcase + ignorecase
  end,
}
