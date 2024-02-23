vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
-- vim.opt.colorcolumn = "80"
vim.opt.clipboard = "unnamedplus" -- access to system clipboard
vim.opt.fileencoding = "utf-8"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.confirm = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.wo.relativenumber = true
local api = vim.api
-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 80,
        })
    end,
})
