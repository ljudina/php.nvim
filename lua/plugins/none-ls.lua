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
        vim.keymap.set("n", "<leader>lx", ":% !tidy -q --input-xml true --indent yes --indent-spaces 4 %<CR>", {
            noremap = true,
            silent = true,
            desc = "Format XML [Tidy]",
        })
        vim.keymap.set("n", "<leader>lj", ":%!jq '.'<CR>", {
            noremap = true,
            silent = true,
            desc = "Format JSON [Jq]",
        })
	end,
}
