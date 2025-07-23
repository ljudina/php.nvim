return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        -- configure treesitter
        local configTS = require("nvim-treesitter.configs")
        configTS.setup({
            auto_install = true,
            highlight = {
                enable = true,
                disable = function(lang, bufnr)
                    if lang == "php" then -- treesitter breaks on large php files
                        local max_filesize = 300 * 1024   -- 100 KB, adjust as needed
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        else
                            return false
                        end
                    end
                    return true
                end,
            },
            indent = { enable = true },
            ensure_installed = {
                "bash",
                "c",
                "diff",
                "html",
                "php",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
        })
    end,
}
