return {
  {"neanias/everforest-nvim",
  lazy = false,
  priority=1000,
  config = function() 
				vim.cmd([[colorscheme everforest]])
		-- Setting to change the color of the inlayhints	
	            vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#4cc9f0" })
	end
}
}
