-- Set alias for global options, window options, and remap function
local o = vim.o
local wo = vim.wo

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Global vim settings
o.autoindent = true
o.autoread = true
o.autowrite = true
o.jumpoptions = "stack,view"
o.backspace = 'indent,eol,start'
o.expandtab = true
o.hlsearch = true
o.ignorecase = true
o.incsearch = true
o.shortmess = 'Sc'
o.showmatch = true
o.smartindent = true
o.softtabstop = 2
o.tabstop = 2
o.termguicolors = true
o.splitbelow = true
o.splitright = true
o.shiftwidth = 2
o.fillchars = ""
o.numberwidth = 2

-- Window Local
wo.number = true
wo.relativenumber = true
wo.wrap = true
wo.linebreak = true

-- -- set the fold expression to defer to the LSP
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevel = 9999

-- persistent undos
o.undofile = true
o.undodir = vim.fn.stdpath('data') .. '/.nvim/undo-dir'

