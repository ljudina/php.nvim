vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.colorcolumn = "128" -- default is "80" but "120" because of erp php project side monitor
vim.opt.clipboard = "unnamedplus" -- access to system clipboard
vim.opt.fileencoding = "utf-8"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.confirm = true
vim.opt.number = true
vim.opt.scrolloff = 8
vim.wo.relativenumber = true
vim.opt.undofile = true
vim.opt.undolevels = 10000
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
-- get visual selection
function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ""
	end
end
