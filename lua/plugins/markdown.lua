return {
    {

        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
            heading = {
                backgrounds = {},
            },
            bullet = { right_pad = 2 },
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        config = function()
            vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', {
                silent = true,
                desc = "Preview markdown [markdown-preview.nvim]"
            })
        end,
        ft = { "markdown" },
    },
}
