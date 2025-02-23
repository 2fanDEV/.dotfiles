return {
	"romgrk/barbar.nvim",
	dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
	opts = {
		animations = true,
		insert_at_start = true,
		icons = {
			gitsigns = {
				added = { enabled = true, icon = "+" },
				changed = { enabled = true, icon = "~" },
				deleted = { enabled = true, icon = "-" },
			},
			separator_at_end = false,
		},
	},
	config = function(_, opts)
		require("barbar").setup(opts)
	end,
}
