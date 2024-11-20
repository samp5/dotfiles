return {
  'sindrets/diffview.nvim',
  config = function()
    local wk = require('which-key')
    wk.add({
      { '<leader>d',  group = '[D]iffview' },
      { '<leader>do', '<cmd>DiffviewOpen<CR>',  desc = "Open Diffview" },
      { '<leader>dc', '<cmd>DiffviewClose<CR>', desc = "Close Diffview" },
      {
        '<leader>dh',
        function()
          local path = vim.fn.expand('%')
          vim.cmd { cmd = "DiffviewFileHistory", args = { path } }
        end,
        desc = "Current buffer file history "
      },
      { '<leader>df', '<cmd>DiffviewFocusFiles<CR>', desc = 'Focus files' },
      {
        "<leader>db",
        function()
          local user_input
          local path = vim.fn.expand('%')
          vim.ui.input({ prompt = "Diff what" },
            function(input)
              user_input = input
              if user_input then
                vim.cmd { cmd = "DiffviewOpen", args = { user_input, "--", path } }
              end
            end)
        end,
        desc = "Select DiffTo"
      }
    })
    vim.opt.fillchars:append { diff = "/" }
  end
}
