return {
    "ggandor/leap.nvim",
    config = function()
        require("leap")
        vim.keymap.set("n", "<A-s>", function()
            local current_window = vim.fn.win_getid()
            require("leap").leap({ target_windows = { current_window } })
        end, {
            silent = true,
            desc = "Search with leap",
        })
    end,
}
