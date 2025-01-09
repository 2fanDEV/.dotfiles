local opt = vim.opt;
local api = vim.api;

opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.softtabstop= 2
opt.shiftwidth= 2
opt.background = "dark"

api.nvim_set_hl(0, "Normal", { bg = "none" })
