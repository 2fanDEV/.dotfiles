return {
	"VidocqH/lsp-lens.nvim",
	opts = {
		enable = true,
		include_declaration = true,
		section = {
			definitions = true,
			references = true,
			implements= true,
			git_authors = true
		}
	},
	config = function(_, opts) 
		require("lsp-lens").setup(opts)
	end
}
