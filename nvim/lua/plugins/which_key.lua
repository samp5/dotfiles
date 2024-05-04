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
      ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
      ['<leader>b'] = { name = 'De[B]ug', _ = 'which_key_ignore' },
      ['<leader>e'] = { name = '[E]xplorer', _ = 'which_key_ignore' },
      ['<leader>x'] = { name = 'Trouble', _ = 'which_key_ignore' },
      ['<leader>c'] = { name = '[C]langd', _ = 'which_key_ignore' },
      ['<leader>n'] = { name = '[N]eogit', _ = 'which_key_ignore' },
      ['<leader>y'] = { '"+y', '[Y]ank to system' },
      ['<leader>o'] = { 'o<Esc>k', 'Open line below (no insert)' },
      ['<leader>O'] = { 'O<Esc>k', 'Open line above (no insert)' },
      ['<leader>p'] = { mode = 'x', '"_dP', 'Past over selection' },
      ["<leader>w"] = {
        name = "[W]indow",
        e = { "<C-w>=", "Equalize Windows" },
        s = { "<C-w>x", "Swap Windows" },
        k = { '10<C-w>>', "Increase window size" },
        j = { '10<C-w><', "Decrease window size" },
        n = { '<C-w>v', "Split vertically" },
        b = { '<C-w>s', "Split horizontally" },
      },
      ["<leader>;"] = { '<Esc>A{<Enter>}<Esc>O', "Semicolons" },

    }
  end,
  opts = {
    window = {
      border = "single",
    }
  },
}
