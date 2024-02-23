return {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            -- init builtin
            local builtin = require("telescope.builtin")
            -- set keymaps
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {
                desc = "Find files [Telescope]"
            })
            vim.keymap.set('n', '<leader>fp', builtin.git_files, {
                desc = "Find Git files [Telescope]"
            })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {
                desc = "Live file grep [Telescope]"
            })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {
                desc = "Buffers [Telescope]"
            })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {
                desc = "Help tags [Telescope]"
            })
            vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {
                desc = "LSP Document symbols [Telescope]"
            })
            vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {
                desc = "Old files [Telescope]"
            })
            vim.keymap.set('n', '<leader>fw',
                function()
                    builtin.grep_string({
                        search = vim.fn.input("Find word > ")
                    })
                end, { desc = "Find word [Telescope]" })
        end
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    }
                }
            })
            require("telescope").load_extension("ui-select")
        end
    }
}
