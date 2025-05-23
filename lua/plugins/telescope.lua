return {
    {
        "nvim-telescope/telescope.nvim",
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            "nvim-lua/plenary.nvim",
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function()
            require('telescope').setup {
                extensions = {
                    fzf = {}
                }
            }
            require('telescope').load_extension('fzf')
            -- init builtin
            local builtin = require("telescope.builtin")
            -- set keymaps
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {
                desc = "Find files [Telescope]",
            })
            vim.keymap.set("v", "<leader>ff", function()
                local text = vim.getVisualSelection()
                builtin.find_files({ default_text = text })
            end, {
                desc = "Find selection in files [Telescope]",
            })
            vim.keymap.set("n", "<leader>fp", builtin.git_files, {
                desc = "Find Git files [Telescope]",
            })
            vim.keymap.set('n', '<leader>fg', function()
              builtin.live_grep({
                additional_args = function()
                  return { "--encoding", "utf-8" }
                end
              })
            end, { desc = "Live file grep UTF-8 [Telescope]" })
            vim.keymap.set("n", "<leader>fq", builtin.resume, {
                desc = "Resume find [Telescope]",
            })
            vim.keymap.set("n", "<leader>fo", function()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                })
            end, { desc = "Live open file grep [Telescope]" })
            vim.keymap.set("v", "<leader>fo", function()
                local text = vim.getVisualSelection()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = "Live Grep selection in Open Files",
                    default_text = text
                })
            end, { desc = "Live open file grep selection [Telescope]" })
            vim.keymap.set("v", "<leader>fg", function()
                local text = vim.getVisualSelection()
                builtin.live_grep({ default_text = text })
            end, {
                desc = "Live file grep selection [Telescope]",
            })
            vim.keymap.set("n", "<leader>fc", function()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end, { desc = "Current file grep [Telescope]" })
            vim.keymap.set("v", "<leader>fc", function()
                local text = vim.getVisualSelection()
                builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                    winblend = 10,
                    previewer = false,
                    default_text = text,
                }))
            end, {
                desc = "Current file grep selection [Telescope]",
            })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {
                desc = "Buffers [Telescope]",
            })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
                desc = "Help tags [Telescope]",
            })
            vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {
                desc = "LSP Document symbols [Telescope]",
            })
            vim.keymap.set("v", "<leader>fs", function()
                local text = vim.getVisualSelection()
                builtin.lsp_document_symbols({ default_text = text })
            end, {
                desc = "LSP Document symbols selection [Telescope]",
            })
            vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {
                desc = "Old files [Telescope]",
            })
            vim.keymap.set("v", "<leader>fr", function()
                local text = vim.getVisualSelection()
                builtin.oldfiles({ default_text = text })
            end, {
                desc = "Old files selection [Telescope]",
            })
            vim.keymap.set("n", "<leader>fw", function()
                builtin.grep_string({
                    search = vim.fn.input("Find word > "),
                })
            end, { desc = "Find word [Telescope]" })
        end,
    },
}
