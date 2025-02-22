-- keymaps
vim.g.mapleader = " "
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
-- Move selected line / block of text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)
-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
-- paste over currently selected text without yanking it
map("v", "p", '"_dp')
map("v", "P", '"_dP')
-- cycle through buffers
map("n", "<C-k>", "<cmd>bnext<CR>zz")
map("n", "<C-j>", "<cmd>bprev<CR>zz")

map("n", "<M-j>", "<cmd>cnext<CR>")
map("n", "<M-k>", "<cmd>cprev<CR>")
map("n", "<M-o>", "<cmd>cope<CR>")
map("n", "<M-q>", "<cmd>ccl<CR>")

-- delete to black hole register (without yanking)
map("n", "<C-x>", '"_dd')
map("v", "<C-x>", '"_d')

-- copy everything between { and } including the brackets
-- p puts text after the cursor,
-- P puts text before the cursor.
vim.keymap.set("n", "YY", "va{Vy", opts)

-- Move line on the screen rather than by line in the file
vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "k", "gk", opts)

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", opts)

vim.keymap.set("n", "<leader>ha", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify('Copied absolute path "' .. path .. '" to the clipboard!')
end, {
    silent = true,
    desc = "Copy absolute path to clipboard",
})

vim.keymap.set("n", "<leader>hr", function()
    local path = vim.fn.expand("%")
    vim.fn.setreg("+", path)
    vim.notify('Copied relative path "' .. path .. '" to the clipboard!')
end, {
    silent = true,
    desc = "Copy relative path to clipboard",
})

vim.keymap.set("n", "<leader>hf", function()
    local path = vim.fn.expand("%:t")
    vim.fn.setreg("+", path)
    vim.notify('Copied filename "' .. path .. '" to the clipboard!')
end, {
    silent = true,
    desc = "Copy filename to clipboard",
})
