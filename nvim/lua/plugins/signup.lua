return {
	"Dan7h3x/signup.nvim",
	branch = "main",
	opts = {},
	config = function(_, opts)
		require("signup").setup(opts)
	end
}
