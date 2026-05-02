return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		lightbulb = {
			enable = false,
			virtual_text = false,
			sign = false,
		},
	},
	config = function(_, opts)
		require("lspsaga").setup(opts)
		require("lspsaga.symbol.winbar").get_bar()
	end,
}
