return {
 	"dstein64/vim-startuptime",
	cmd = "StartUpTime",
	init = function() 
		vim.g.startuptime_tries = 10
	end,
}
