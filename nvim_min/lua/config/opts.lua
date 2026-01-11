local o = vim.o
local wo = vim.wo

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Global vim settings
o.autoread = true
o.autowrite = true

o.hlsearch = true

o.softtabstop = 2
o.tabstop = 2
o.shiftwidth = 2
o.numberwidth = 2
o.expandtab = true
o.autoindent = true

o.splitbelow = true
o.splitright = true

o.termguicolors = true

-- Window Local
wo.number = true
wo.relativenumber = true
wo.wrap = true
wo.linebreak = true

-- set the fold expression to defer to the LSP
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevel = 9999

-- persistent undos
o.undofile = true
o.undodir = vim.fn.stdpath('data') .. '/.nvim/undo-dir'

