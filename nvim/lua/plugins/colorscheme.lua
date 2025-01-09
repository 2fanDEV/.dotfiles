return {
  {"folke/tokyonight.nvim",
  lazy = false,
  priority=1000,
  config = function() 
		vim.cmd([[colorscheme tokyonight-storm]])
		-- Setting to change the color of the inlayhints
		vim.api.nvim_set_hl(0, "InlayHint", {fg = "#9DA9A0"})
  end}
}
