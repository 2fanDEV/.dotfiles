return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "rust" },
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
	},
	config = function(_, opts)
		local configs = require("nvim-treesitter.configs")
		configs.setup({opts})
	end,
}
