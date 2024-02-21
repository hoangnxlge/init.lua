local opt = vim.opt
vim.g.mapleader = " "
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.syntax = "on"
opt.number = true
opt.relativenumber = true
opt.ignorecase = true
opt.colorcolumn = "80"
opt.signcolumn = "yes:1"

require("plugins")
require("keymaps")

