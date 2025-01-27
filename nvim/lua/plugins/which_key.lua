return {
  "folke/which-key.nvim",
  lazy = true,
  event = "BufEnter",
  dependencies = "echasnovski/mini.icons",
  opts = {
    preset = "modern",
    notify = false,
    win = {
      title = false,
    }
  },
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require "which-key".add({
      { "<M-n>",      "<C-w>5<",                     desc = "Decrease size" },
      { "<M-s>",      "<C-w>-",                      desc = "Decrease size" },
      { "<M-t>",      "<C-w>+",                      desc = "Decrease size" },
      { "<M-w>",      "<C-w>5>",                     desc = "Increase size" },


      { "<leader>cl", "<cmd>nohl<CR>",               desc = "Clear search highlighting" },

      { "<leader>tn", "<cmd>vsplit term://fish<CR>", desc = "Terminal (vertical)" },
      { "<leader>tb", "<cmd>split term://fish<CR>",  desc = "Terminal (Horizonal)" },

      { "<leader>O",  "O<Esc>k",                     desc = "Open line above (no insert)" },
      { "<leader>o",  "o<Esc>k",                     desc = "Open line below (no insert)" },
      { "<leader>w",  group = "[W]indow" },
      { "<leader>wb", "<C-w>s",                      desc = "Split horizontally" },
      { "<leader>wq", "<cmd>close<CR>",              desc = "Close split" },
      { "<leader>we", "<C-w>=",                      desc = "Equalize Windows" },
      { "<leader>wn", "<C-w>v",                      desc = "Split vertically" },
      { "<leader>ws", "<C-w>x",                      desc = "Swap Windows" },
      { "<leader>p",  '"_dP',                        desc = "Past over selection",           mode = "x" },
      { "<leader>y",  '"+y',                         desc = "[Y]ank to system",              mode = { "v", "x" } },
      { "<C-u>",      "<C-u>zz",                     desc = "Move up half page and center" },
      { "<C-d>",      "<C-d>zz",                     desc = "Move down half page and center" },
      { "n",          "nzzzv",                       desc = "Next, center, open folds" },
      { "N",          "Nzzzv",                       desc = "Previous center, open folds" },
      { "<C-o>",      "<C-o>zz",                     desc = "Jump back center" },
      { "<C-i>",      "<C-i>zz",                     desc = "Jump forward center" },
      { "Q",          "<nop>" },

    })
  end,
}
