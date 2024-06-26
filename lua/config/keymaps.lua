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

map("n", "<C-k>", "<cmd>bnext<CR>zz")
map("n", "<C-j>", "<cmd>bprev<CR>zz")

map("n", "<leader>cn", "<cmd>cnext<CR>")
map("n", "<leader>cp", "<cmd>cprev<CR>")
map("n", "<leader>co", "<cmd>cope<CR>")
map("n", "<leader>cc", "<cmd>ccl<CR>")
