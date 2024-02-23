return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {
        plugins = { spelling = true },
        defaults = {
            ["<leader>l"] = { name = "LSP" },
            ["<leader>g"] = { name = "Git [LazyGit]" },
            ["<leader>f"] = { name = "Find [Telescope]" },
            ["<leader>x"] = { name = "Troubleshoot [Trouble]" },
            ["<leader>h"] = { name = "File List [Harpoon]" },
            ["<leader>a"] = { name = "Annotate [Neogen]" },
            ["<leader>b"] = { name = "Buffer [mini-buffremove]" },
            ["<leader>d"] = { name = "Debug [DAP]" },
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.defaults)
    end,
}
