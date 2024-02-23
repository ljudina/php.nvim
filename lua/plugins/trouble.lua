return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("trouble").setup()
		vim.keymap.set("n", "<leader>xx", function()
			require("trouble").toggle()
		end, { desc ="Toggle Trouble" })
		vim.keymap.set("n", "<leader>xw", function()
			require("trouble").toggle("workspace_diagnostics")
		end, { desc ="Toggle Trouble Workspace" })
		vim.keymap.set("n", "<leader>xd", function()
			require("trouble").toggle("document_diagnostics")
		end, { desc ="Toggle Trouble Document" })
		vim.keymap.set("n", "<leader>xq", function()
			require("trouble").toggle("quickfix")
		end, { desc ="Toggle Trouble Quickfix" })
		vim.keymap.set("n", "<leader>xl", function()
			require("trouble").toggle("loclist")
		end, { desc ="Toggle Trouble Location list" })
		vim.keymap.set("n", "<leader>xr", function()
			require("trouble").toggle("lsp_references")
		end, { desc ="Toggle Trouble LSP references" })
	end,
}
