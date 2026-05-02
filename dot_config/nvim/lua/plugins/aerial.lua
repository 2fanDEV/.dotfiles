return {
	"stevearc/aerial.nvim",
	opts = {
		on_attach = function (bufnr)
			vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
			vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
		end,
		-- toggle aerial
		vim.keymap.set("n", "<Leader>a", "<cmd>AerialToggle!<CR>")
	},
	configuration = function (_, opts)
			require("aerial").setup(opts)
	end
}
