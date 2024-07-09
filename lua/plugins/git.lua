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
			vim.keymap.set("n", "<leader>gn", ":Gitsigns next_hunk<CR>", {
				desc = "Next change [GitSigns]",
				silent = true,
			})
			vim.keymap.set("n", "<leader>gp", ":Gitsigns prev_hunk<CR>", {
				desc = "Previous change [GitSigns]",
				silent = true,
			})
		end,
	},
}
