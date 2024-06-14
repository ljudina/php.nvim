return {
	"vim-test/vim-test",
	config = function()
		vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>", {
			noremap = true,
			silent = true,
			desc = "Test nearest [Vim test]",
		})
		vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", {
			noremap = true,
			silent = true,
			desc = "Test file [Vim test]",
		})
		vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>", {
			noremap = true,
			silent = true,
			desc = "Test suite [Vim test]",
		})
		vim.keymap.set("n", "<leader>tl", ":TestLast<CR>", {
			noremap = true,
			silent = true,
			desc = "Test last [Vim test]",
		})
		vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>", {
			noremap = true,
			silent = true,
			desc = "Test visit [Vim test]",
		})
	end,
}
