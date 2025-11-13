return {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    opts = {
        servers = {
            html = {},
            lua_ls = {
                settings = {
                    Lua = {
                        format = {
                            enable = true,
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "4",
                            },
                        },
                    },
                },
            },
            intelephense = {
                settings = {
                    intelephense = {
                        format = {
                            braces = "k&r", -- or "allman", "psr12"
                        },
                    },
                },
            },
            vtsls = {
                settings = {
                    typescript = {
                        format = {
                            semicolons = "insert",
                        },
                    },
                    javascript = {
                        format = {
                            semicolons = "insert",
                        },
                    },
                },
            },

            gopls = {},
            sqlls = {},
        },
    },
    completion = {
        menu = { border = 'single' },
        documentation = { window = { border = 'single' } },
    },
    signature = { window = { border = 'single' } },
    config = function(_, opts)
        for server, config in pairs(opts.servers) do
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            vim.lsp.config(server, config)
            vim.lsp.enable(server)
        end
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {
            desc = "Format buffer [LSP]",
        })
        -- Optional: format on save for LSP-supported buffers
        -- vim.api.nvim_create_autocmd("BufWritePre", {
        --     callback = function(args)
        --         vim.lsp.buf.format({ bufnr = args.buf })
        --     end,
        -- })
        vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", {
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
