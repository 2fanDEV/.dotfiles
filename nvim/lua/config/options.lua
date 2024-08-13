local keymap = vim.keymap
local opt = vim.opt
local cmd = vim.cmd
local api = vim.api

opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.background = "dark"

cmd("colorscheme oxocarbon")
api.nvim_set_hl(0, "Normal", { bg = "none" })
api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

keymap.set("n", "ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true })

