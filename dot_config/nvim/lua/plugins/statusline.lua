return { 
	"beauwilliams/statusline.lua",
	opts = {
	},
	config = function()
		local statusline = require("statusline")
		statusline.tabline = false
	end
}
