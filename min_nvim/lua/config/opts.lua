local sys = require('sys')

vim.g.mapleader = " "

vim.o.autoindent = true
vim.o.autoread = true			-- Reread when changed outside vim

-- Visual Line formatting
vim.o.breakindent = true	-- Indent wrapped lines

vim.o.expandtab = false
vim.o.joinspaces = true
vim.o.fileencoding = 'UTF-8'
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.shiftwidth = 2
vim.o.shortmess = "Sc"
vim.o.showmatch = true
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false

-- Persistent undos
vim.o.undofile = true
if sys.is_linux or sys.is_macos then
	vim.o.undodir = os.getenv('HOME') .. '/.nvim/undo-dir'
elseif sys.is_windows then
	vim.o.undodir = vim.fn.stdpath('data') .. '\\undo-dir'
end

