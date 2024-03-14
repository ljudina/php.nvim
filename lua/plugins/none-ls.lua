return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- lua
				null_ls.builtins.formatting.stylua,
				-- js
				null_ls.builtins.formatting.biome,
                null_ls.builtins.code_actions.statix,
                -- obsolete
				-- null_ls.builtins.diagnostics.eslint,
				-- null_ls.builtins.formatting.eslint,
			},
		})
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {
			desc = "Format buffer [LSP]",
		})
	end,
}
