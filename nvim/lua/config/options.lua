local opt = vim.opt;
local api = vim.api;


vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true


opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.softtabstop= 2
opt.shiftwidth= 2
opt.background = "dark"
api.nvim_set_hl(0, "Normal", { bg = "none" })
