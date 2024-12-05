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

o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'

-- persistent undos
o.undofile = true
o.undodir = vim.fn.stdpath('data') .. '/.nvim/undo-dir'
