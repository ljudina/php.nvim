return {
  "justinmk/vim-sneak",
  event = "VeryLazy",
  config = function()
    vim.g["sneak#label"] = 1        -- show labels for targets
    vim.g["sneak#use_ic_scs"] = 1   -- smartcase + ignorecase
    vim.g["sneak#disable_default_mappings"] = 1 -- disable s / S mappings from Sneak
    -- Custom mappings: Alt+s and Alt+S
    vim.keymap.set({ "n", "x", "o" }, "<leader>s", "<Plug>Sneak_s")
    vim.keymap.set({ "n", "x", "o" }, "<leader>S", "<Plug>Sneak_S")
    -- Restore vim's default S behavior (change line)
    vim.keymap.set("n", "S", "cc", { noremap = true })
  end,
}
