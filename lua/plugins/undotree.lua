return {
    "mbbill/undotree",
    config = function()
        -- init keymap
        vim.keymap.set('n', '<leader>ut', ':UndotreeToggle<CR>', {
            silent = true,
            desc = "Undotree Toggle"
        })
    end
}
