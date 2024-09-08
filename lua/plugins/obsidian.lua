return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("obsidian").setup({
            ui = {enable = false},
			workspaces = {
				{
					name = "vault",
					path = "~/ObsidianVault/ljudina",
				},
			},
			completion = {
				nvim_cmp = true,
				min_chars = 2,
				new_notes_location = "current_dir",
				prepend_note_id = true,
			},
			templates = {
				folder = "Templates",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
			},
		})
	end,
}
