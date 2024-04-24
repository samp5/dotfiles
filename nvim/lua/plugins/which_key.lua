return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require('which-key').setup({
      window = {
        border = "single",
      }
    }
    )

    require('which-key').register {
      ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
      ['<leader>w'] = { name = '[W]indow', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
      ['<leader>b'] = { name = 'De[B]ug', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[D]iffview', _ = 'which_key_ignore' },
      ['<leader>e'] = { name = '[E]xplorer', _ = 'which_key_ignore' },
      ['<leader>x'] = { name = 'Trouble', _ = 'which_key_ignore' },
      ['<leader>c'] = { name = '[C]langd', _ = 'which_key_ignore' },
      ['<leader>p'] = { name = '[P]ick', _ = 'which_key_ignore' },
    }
  end,
  opts = {
    window = {
      border = "single",
    }
  },
}
