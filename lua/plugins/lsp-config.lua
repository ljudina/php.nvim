return {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
        local servers = { 'lua_ls', 'intelephense', 'vtsls', 'gopls', 'sqlls' }

        -- superhtml LSP for HTML files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "html", "shtml", "htm" },
            callback = function()
                vim.lsp.start({
                    name = "superhtml",
                    cmd = { "superhtml", "lsp" },
                    root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
                    capabilities = require('blink.cmp').get_lsp_capabilities(),
                })
            end,
        })

        -- Merge blink.cmp capabilities into all servers
        vim.lsp.config('*', {
            capabilities = require('blink.cmp').get_lsp_capabilities(),
        })

        -- Server-specific configs are in lsp/*.lua files (0.12 convention)
        vim.lsp.enable(servers)

        -- Keymaps (leader-l prefix for LSP, gr* defaults also available in 0.12)
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {
            desc = "Format buffer [LSP]",
        })
        vim.keymap.set("n", "<leader>li", ":checkhealth vim.lsp<CR>", {
            desc = "Show information [LSP]",
        })
        vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, {
            desc = "Hover buffer [LSP]",
        })
        vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, {
            desc = "Go do definition [LSP]",
        })
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, {
            desc = "Go do references [LSP]",
        })
        vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, {
            desc = "Code action [LSP]",
        })
        vim.keymap.set("n", "<leader>lm", vim.lsp.buf.implementation, {
            desc = "Show implementation [LSP]",
        })
        vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, {
            desc = "Rename symbol [LSP]",
        })
        vim.keymap.set("n", "<leader>lx",
            ":% !tidy -q --input-xml true --indent yes --indent-spaces 4 %<CR>",
            {
                noremap = true,
                silent = true,
                desc = "Format XML [Tidy]",
            }
        )
        vim.keymap.set("n", "<leader>lj",
            ":%!jq '.'<CR>",
            {
                noremap = true,
                silent = true,
                desc = "Format JSON [Jq]",
            }
        )
    end,
}
