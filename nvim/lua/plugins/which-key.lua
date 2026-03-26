return {
  "folke/which-key.nvim",
  opts = {
    delay = 50,
    preset = "helix",
    notify = false,
    win = {
      title = false,
    },
  },
  keys = {
    { "<M-n>", "<C-w>5<", desc = "Decrease size" },
    { "<M-s>", "<C-w>-", desc = "Decrease size" },
    { "<M-t>", "<C-w>+", desc = "Decrease size" },
    { "<M-w>", "<C-w>5>", desc = "Increase size" },

    { "<leader>O", "O<Esc>k", desc = "Open line above (no insert)" },
    { "<leader>o", "o<Esc>k", desc = "Open line below (no insert)" },

    -- Window Ops
    { "<leader>w", group = "[W]indow", icon = " " },
    { "<leader>wb", "<C-w>s", desc = "Split horizontally" },
    { "<leader>wq", "<cmd>close<CR>", desc = "Close split" },
    { "<leader>we", "<C-w>=", desc = "Equalize Windows" },
    { "<leader>wn", "<C-w>v", desc = "Split vertically" },

    { "<leader>p", '"_dP', desc = "Past over selection", mode = "x" },
    { "<leader>y", '"+y', desc = "[Y]ank to system", mode = { "v", "x" } },
    { "n", "nzzzv", desc = "Next, center, open folds" },
    { "N", "Nzzzv", desc = "Previous center, open folds" },
    { "<C-o>", "<C-o>zz", desc = "Jump back center" },
    { "<C-i>", "<C-i>zz", desc = "Jump forward center" },
    { "Q", "<nop>" },

    { "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", { silent = true } },
    { "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", { silent = true } },
    { "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", { silent = true } },
    { "<C-j>", "<Cmd>NvimTmuxNavigateUp<CR>", { silent = true } },
  },
}
