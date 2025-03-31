return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    ft = { 'sql', 'mysql', 'plsql' },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      local wk = require 'which-key'
      wk.add({
        { "<leader>es", function() vim.cmd('DBUIToggle') end,     desc = "[E]xpore [S]ql databases" },
        { "<leader>sb", function() vim.cmd('DBUIFindBuffer') end, desc = "Attach buffer to DB" }
      })
    end,
  },
}
