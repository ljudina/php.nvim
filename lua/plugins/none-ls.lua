return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- lua
				null_ls.builtins.formatting.stylua,
				-- js
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.formatting.eslint_d,
			},
		})
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {
			desc = "Format buffer [LSP]",
		})
	end,
}
