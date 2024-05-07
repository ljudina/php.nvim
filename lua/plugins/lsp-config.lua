return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.html.setup({
				capabilites = capabilities,
			})

			lspconfig.lua_ls.setup({
				capabilites = capabilities,
			})

			lspconfig.intelephense.setup({
				capabilites = capabilities,
			})

			lspconfig.eslint.setup({
				capabilites = capabilities,
			})

			lspconfig.gopls.setup({
				capabilites = capabilities,
			})

			lspconfig.sqlls.setup({
				capabilites = capabilities,
			})

			vim.keymap.set("n", "<leader>li", ":LspInfo<CR>", {
				desc = "Show information [LSP]",
			})

			vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, {
				desc = "Hover buffer [LSP]",
			})
			vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, {
				desc = "Go do definition [LSP]",
			})
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, {
				desc = "Go do references [LSP]",
			})
			vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action,  {
				desc = "Code action [LSP]",
			})
			vim.keymap.set("n", "<leader>lm", vim.lsp.buf.implementation,  {
				desc = "Show implementation [LSP]",
			})
		end,
	},
}
