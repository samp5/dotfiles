return {
  "folke/which-key.nvim",
  dependencies = "echasnovski/mini.icons",
  priority = 1000,
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require('which-key').setup({
      window = {
        border = "single",
      }
    }
    )

    require "which-key".add({
      { "<M-n>",      "<C-w>5<",         desc = "Decrease size" },
      { "<M-s>",      "<C-w>-",          desc = "Decrease size" },
      { "<M-t>",      "<C-w>+",          desc = "Decrease size" },
      { "<M-w>",      "<C-w>5>",         desc = "Increase size" },

      { "<leader>cl", "<cmd>nohl<CR>",   desc = "Clear search highlighting" },

      { "<leader>O",  "O<Esc>k",         desc = "Open line above (no insert)" },
      { "<leader>o",  "o<Esc>k",         desc = "Open line below (no insert)" },
      { "<leader>w",  group = "[W]indow" },
      { "<leader>wb", "<C-w>s",          desc = "Split horizontally" },
      { "<leader>wq", "<cmd>close<CR>",  desc = "Close split" },
      { "<leader>we", "<C-w>=",          desc = "Equalize Windows" },
      { "<leader>wn", "<C-w>v",          desc = "Split vertically" },
      { "<leader>ws", "<C-w>x",          desc = "Swap Windows" },
      { "<leader>p",  '"_dP',            desc = "Past over selection",           mode = "x" },
      { "<leader>y",  '"+y',             desc = "[Y]ank to system" },
      { "<C-u>",      "<C-u>zz",         desc = "Move up half page and center" },
      { "<C-d>",      "<C-d>zz",         desc = "Move down half page and center" },
      { "n",          "nzzzv",           desc = "Next, center, open folds" },
      { "N",          "Nzzzv",           desc = "Previous center, open folds" },
      { "<C-o>",      "<C-o>zz",         desc = "Jump back center" },
      { "<C-i>",      "<C-i>zz",         desc = "Jump forward center" },
      { "<C-o>",      "<C-o>zz",         desc = "Jump back center" },
      { "<C-i>",      "<C-i>zz",         desc = "Jump forward center" },
      { "<leader>d",  '"_d',             mode = { "n", "v" },                    desc = "Delete" },
      { "Q",          "<nop>" },

    })
    -- vim.keymap.set('i', "<M-'>", '<Esc>A{<Enter>}<Esc>O', { noremap = true, desc = 'Brackets (the right way)' })
    -- vim.keymap.set('n', "<M-'>", 'A{<Enter>}<Esc>O', { noremap = true, desc = 'Brackets (the right way)' })
    -- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, desc = "Move selection up" })
    -- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, desc = "Move selection down" })
    -- vim.keymap.set("v", "<CR>", ":w !xargs xdg-open<CR>", { noremap = true, silent = true, desc = "Open links" })
  end,
  opts = {
    window = {
      border = "single",
    }
  },
}
