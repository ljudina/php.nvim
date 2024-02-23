return {
	{
		"kdheepak/lazygit.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", {
				desc = "Open git [LazyGit]",
			})
			vim.keymap.set("n", "<leader>gp", ":LazyGitFilter<CR>", {
				desc = "Open project commits [LazyGit]",
			})
			vim.keymap.set("n", "<leader>gf", ":LazyGitFilterCurrentFile<CR>", {
				desc = "Open file commits [LazyGit]",
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
}
