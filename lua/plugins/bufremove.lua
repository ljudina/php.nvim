return {
    "famiu/bufdelete.nvim",
    config = function ()
        vim.keymap.set("n", "<leader>bd", ":Bdelete<CR>", {
            silent = true,
            desc = "Buffer delete",
        })
        vim.keymap.set("n", "<leader>ba", ":bufdo bwipeout<CR>", {
            silent = true,
            desc = "Delete all buffers",
        })
        vim.keymap.set("n", "<leader>bw", ":Bwipeout<CR>", {
            silent = true,
            desc = "Buffer wipeout",
        })
        vim.keymap.set("n", "<leader>bx", ":call delete(expand('%')) | bdelete!<CR>", {
            silent = true,
            desc = "Delete current file with buffer",
        })
        vim.keymap.set("n", "<leader>bo", ":wv!<CR>", {
            silent = true,
            desc = "Delete oldfiles list",
        })
    end
}
