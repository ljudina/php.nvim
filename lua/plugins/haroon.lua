return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        -- initial setup
        local harpoon = require("harpoon")
        harpoon:setup()
        -- basic telescope configuration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers")
                .new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                })
                :find()
        end
        vim.keymap.set("n", "<leader>ht", function()
            toggle_telescope(harpoon:list())
        end, { desc = "Open harpoon window [Telescope]" })
        -- Standard keymap
        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():append()
        end, { desc = "Add file to harpoon" })

        vim.keymap.set("n", "<leader>hl", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Show files in harpoon" })

        vim.keymap.set("n", "<leader>h1", function()
            harpoon:list():select(1)
        end, { desc = "Go to first harpoon file" })

        vim.keymap.set("n", "<leader>h2", function()
            harpoon:list():select(2)
        end, { desc = "Go to second harpoon file" })

        vim.keymap.set("n", "<leader>h3", function()
            harpoon:list():select(3)
        end, { desc = "Go to third harpoon file" })

        vim.keymap.set("n", "<leader>h4", function()
            harpoon:list():select(4)
        end, { desc = "Go to fourth harpoon file" })

        vim.keymap.set("n", "<leader>hp", function()
            harpoon:list():prev()
        end, { desc = "Toggle previous file" })

        vim.keymap.set("n", "<leader>hn", function()
            harpoon:list():next()
        end, { desc = "Toggle next file" })
    end,
}
