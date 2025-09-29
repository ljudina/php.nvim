return {
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = { 'rafamadriz/friendly-snippets' },

        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = 'default' },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            completion = {
                -- Show documentation when selecting a completion item
                documentation = { auto_show = true, auto_show_delay_ms = 800 },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lsp = {
                        fallbacks = {}
                    },
                    buffer = {
                        score_offset = -3,
                        opts = {
                          -- IMPORTANT: only scan the current buffer (fast + predictable)
                          get_bufnrs = function()
                            return { vim.api.nvim_get_current_buf() }
                          end,

                          -- Lift the size guards so large files aren’t skipped
                          -- (tweak to taste; these are safe defaults)
                          max_sync_buffer_size  = 100000,    -- characters
                          max_async_buffer_size = 4000000,  -- characters
                          max_total_buffer_size = 6000000,  -- across scanned bufs

                          use_cache = true,        -- reduce CPU churn on big files
                          min_keyword_length = 2,  -- optional: start matching earlier
                          max_items = 200,         -- optional: cap list length
                        },
                    }
                },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
            -- Experimental signature help support
            signature = { enabled = true }
        },
        opts_extend = { "sources.default" },
    },
}
