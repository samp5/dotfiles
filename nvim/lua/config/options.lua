-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false
vim.g.autoformat = false
vim.b.autoformat = false
vim.opt.clipboard = ""
vim.wo.colorcolumn = "80"

vim.opt.expandtab=false
vim.opt.shiftwidth=0
vim.opt.tabstop = 3

vim.opt.list = true
vim.opt.listchars = { tab = '->', space = '·', eol = '󰌑' }
