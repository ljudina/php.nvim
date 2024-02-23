return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
          transparent_background = true,
          integrations = {
            telescope = true,
            harpoon = true,
            mason = true,
            treesitter = true,
            nvimtree = true,
          }
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            -- set color scheme
            vim.cmd.colorscheme "catppuccin"
        end
    }
}
