return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = true,
    event = "VimEnter",
    lazy = true,
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
        }
        dashboard.section.buttons.val = {
            dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
            dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
            dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
            dashboard.button("s", " " .. "Restore Session", '<cmd>lua require("persistence").load()<cr>'),
            dashboard.button("c", " " .. " Config", ":e ~/.config/nvim/ <CR>"),
            dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
            dashboard.button("q", " " .. " Quit", ":qa<CR>"),
        }
        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"
        dashboard.opts.layout[1].val = 8
        return dashboard
    end,
    config = function(_, dashboard)
        -- local alpha = require("alpha")
        -- local dashboard = require("alpha.themes.startify")
        -- alpha.setup(dashboard.opts)
        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                local version_info = vim.version()
                local nvim_version = "v" .. version_info.major .. "." .. version_info.minor .. "." .. version_info.patch
                local footer = "⚡ Neovim " .. nvim_version .. " loaded " .. stats.count .. " plugins in " .. ms .. "ms"

                -- Fetch latest version asynchronously via the releases/latest redirect
                -- (avoids api.github.com rate limit and the jq dependency)
                local latest_version = ""
                local function fetch_latest_version()
                    local handle = io.popen(
                    "curl -sLI -o /dev/null -w '%{url_effective}' https://github.com/neovim/neovim/releases/latest")
                    if handle then
                        local final_url = handle:read("*a"):gsub("%s+$", "")
                        handle:close()
                        latest_version = final_url:match("/tag/(.+)$") or ""
                        if latest_version ~= "" and latest_version ~= nvim_version then
                            footer = "⚡ Neovim " .. nvim_version .. "  "
                            footer = footer .. "loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                            dashboard.section.footer.val = footer
                            pcall(vim.cmd.AlphaRedraw)
                        end
                    end
                end

                vim.loop.new_timer():start(0, 0, vim.schedule_wrap(fetch_latest_version))

                dashboard.section.footer.val = footer
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
        vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
        vim.api.nvim_create_autocmd("User", {
            pattern = "BDeletePost*",
            group = "alpha_on_empty",
            callback = function(event)
                local fallback_name = vim.api.nvim_buf_get_name(event.buf)
                local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
                local fallback_on_empty = fallback_name == "" and fallback_ft == ""

                if fallback_on_empty then
                    vim.cmd("Alpha")
                end
            end,
        })
    end,
}
