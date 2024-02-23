return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		require("todo-comments").setup({
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--glob=!app/Vendor",
					"--glob=!app/webroot",
					"--glob=!app/Plugin",
					"--glob=!lib/Cake",
				},
			},
		})
		-- init keymap
		vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", {
			silent = true,
			desc = "List all todos [Telescope]",
		})
	end,
}
