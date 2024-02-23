return {
    "echasnovski/mini.bufremove",
    version = false,
    config = function()
        require("mini.bufremove").setup()
        -- init keymap
        vim.keymap.set("n", "<leader>bd", ":lua MiniBufremove.delete()<CR>", {
            silent = true,
            desc = "Buffer delete",
        })
        vim.keymap.set("n", "<leader>bw", ":lua MiniBufremove.wipeout()<CR>", {
            silent = true,
            desc = "Buffer wipeout",
        })
        vim.keymap.set("n", "<leader>bu", ":lua MiniBufremove.unshow()<CR>", {
            silent = true,
            desc = "Buffer unshow",
        })
        vim.keymap.set("n", "<leader>bn", ":lua MiniBufremove.unshow_in_window()<CR>", {
            silent = true,
            desc = "Buffer unshow in window",
        })
        vim.keymap.set("n", "<leader>bx", ":call delete(expand('%')) | bdelete!<CR>", {
            silent = true,
            desc = "Delete current file with buffer",
        })
    end,
}
