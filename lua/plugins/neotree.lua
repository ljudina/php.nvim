return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    config = function()
        -- init keymap
        vim.keymap.set('n', '<C-o>', ':Neotree toggle left<CR>', {
            silent = true,
            desc = "Toggle File Explorer"
        })
    end
}
