return {
	"olimorris/codecompanion.nvim",
	opts= {
		log_level = "DEBUG",
	},
	config = function(_, opts)
		require("codecompanion").setup(opts)
	end
}
