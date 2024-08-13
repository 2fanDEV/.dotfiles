return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = { "c", "lua", "vim", "vimdoc", "rust", "javascript", "typescript", "java" },
		highlight = { enable = true },
		auto_install = true,
		sync_install = true,
		indent = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
		function()
			local treesitter_parser_config = require("nvim-treesitter.parser").get_parser_configs()
			treesitter_parser_config.templ = {
				install_info = {
					install_info = {
						url = "https://github.com/vrischmann/tree-sitter-templ.git",
						files = { "src/parser.c", "src/scanner.c" },
						branch = "master",
					},
				},
			}
		end,
	},
}
