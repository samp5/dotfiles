return {
  "mbbill/undotree",
  lazy = true,
  config = function()
    local wk = require 'which-key'
    wk.add({
      { '<leader><F5>', '<cmd>UndotreeToggle<CR>', desc = 'Undotree' },
    })
    vim.cmd("let g:undotree_TreeNodeShape = ''")
    vim.cmd("let g:undotree_TreeVertShape = ''")
    vim.cmd("let g:undotree_TreeReturnShape = ''")
    vim.cmd("let g:undotree_TreeSplitShape = ''")
    -- window layout 3 has the diff the same width as the tree
    vim.cmd("let g:undotree_WindowLayout = 4")
  end,
}
