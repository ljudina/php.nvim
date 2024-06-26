return {
    "shortcuts/no-neck-pain.nvim",
    config = function()
        require("no-neck-pain").setup({
            width = 140,
            buffers = {
                right = {
                    enabled = false,
                },
            },
        })
        vim.keymap.set("n", "<leader>cs", ":NoNeckPain<CR>", {
            silent = true,
            desc = "Center [buffer] screen [No neck pain]",
        })
    end,
}
