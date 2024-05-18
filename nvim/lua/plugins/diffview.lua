return {
  'sindrets/diffview.nvim',
  config = function()
    vim.keymap.set("n", "<leader>dw", function()
        local user_input
        vim.ui.input({ prompt = "Diff to?" },
          function(input)
            user_input = input
            if user_input then
              vim.cmd { cmd = "DiffviewOpen", args = { user_input } }
            end
          end)
      end,
      { noremap = true, silent = true, desc = "Select Diff to" }
    )
    local wk = require('which-key')

    wk.register({
      ['<leader>d'] = {
        name = "[D]iffview",
        o = { '<cmd>DiffviewOpen<CR>', "Open Diffview" },
        c = { '<cmd>DiffviewClose<CR>', 'Close Diffview' },
        f = { '<cmd>DiffviewFocusFiles<CR>', 'Focus files' },
        h = { '<cmd>DiffviewFileHistory<CR>', 'File history' },
        s = { '<cmd>DiffviewFileHistory -g --range=stash<CR>', 'Stash Diffs' },
      }
    })

    vim.opt.fillchars:append { diff = "/" }
  end
}
