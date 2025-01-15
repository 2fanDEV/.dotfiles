return {
	"gelguy/wilder.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	opts = function()
		local wilder = require("wilder")
		wilder.setup({ modes = { ":", "/", "?" } })
wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
    highlights = {
      border = 'Normal', -- highlight to use for the border
    },
		left = {' ', wilder.popupmenu_devicons()},
		right = {' ', wilder.popupmenu_scrollbar()},
    border = 'rounded',
  })
))
	end,
	config = function(_, opts) end,
}
