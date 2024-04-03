local nnoremap = require("maps").nnoremap
return {
  "mbbill/undotree",
  config = function()
    nnoremap("<leader><F5>", '<cmd>UndotreeToggle<CR>', 'Undotree')
    vim.cmd("let g:undotree_TreeNodeShape = ''")
    vim.cmd("let g:undotree_TreeVertShape = ''")
    vim.cmd("let g:undotree_TreeReturnShape = ''")
    vim.cmd("let g:undotree_TreeSplitShape = ''")
    -- window layout 3 has the diff the same width as the tree
    vim.cmd("let g:undotree_WindowLayout = 4")
  end,
}
