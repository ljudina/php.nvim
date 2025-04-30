return {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },

    -- example using `opts` for defining servers
    opts = {
        servers = {
            html = {},
            lua_ls = {},
            intelephense = {},
            eslint = {},
            gopls = {},
            sqlls = {},
        }
    },
    completion = {
        menu = { border = 'single' },
        documentation = { window = { border = 'single' } },
    },
    signature = { window = { border = 'single' } },
    config = function(_, opts)
        local lspconfig = require('lspconfig')
        for server, config in pairs(opts.servers) do
            -- passing config.capabilities to blink.cmp merges with the capabilities in your
            -- `opts[server].capabilities, if you've defined it
            config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end
        lspconfig['intelephense'].setup {
          settings = {
            intelephense = {
              format = {
                braces = "k&r",
              },
            },
          },
        }
        -- LSP keymaps
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
        vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action,  {
            desc = "Code action [LSP]",
        })
        vim.keymap.set("n", "<leader>lm", vim.lsp.buf.implementation,  {
            desc = "Show implementation [LSP]",
        })
    end
}
