return {
	"deathbeam/lspecho.nvim",
	opts = {
		echo = true,
		decay = 3000,
		interval = 100,
	},
	config = function(_, opts)
		require("lspecho").setup(opts)
end
}
