local d2_diagram = function()
  vim.cmd([['<,'>!d2 - --ascii-mode standard --stdout-format txt 2> /dev/null]])
end

return {
  "folke/which-key.nvim",
  lazy = true,
  event = "BufEnter",
  dependencies = "echasnovski/mini.icons",
  opts = {
    delay = 50,
    preset = "helix",
    notify = false,
    win = {
      title = false,
    }
  },
  config = function()
    require "which-key".add({
      -- Pane sizing
      { "<M-n>", "<C-w>5<", desc = "Decrease size" },
      { "<M-s>", "<C-w>-", desc = "Decrease size" },
      { "<M-t>", "<C-w>+", desc = "Decrease size" },
      { "<M-w>", "<C-w>5>", desc = "Increase size" },

      -- Terminals
      { "<leader>cl", "<cmd>nohl<CR>", desc = "Clear search highlighting" },
      { "<leader>tn", "<cmd>vsplit term://fish<CR>", desc = "Terminal (vertical)" },
      { "<leader>tb", "<cmd>split term://fish<CR>", desc = "Terminal (Horizonal)" },

      { "<leader>O", "O<Esc>k", desc = "Open line above (no insert)" },
      { "<leader>o", "o<Esc>k", desc = "Open line below (no insert)" },

      -- Window Ops
      { "<leader>w", group = "[W]indow", icon = " " },
      { "<leader>wb", "<C-w>s", desc = "Split horizontally" },
      { "<leader>wq", "<cmd>close<CR>", desc = "Close split" },
      { "<leader>we", "<C-w>=", desc = "Equalize Windows" },
      { "<leader>wn", "<C-w>v", desc = "Split vertically" },
      { "<leader>ws", "<C-w>x", desc = "Swap Windows" },

      { "<leader>p", '"_dP', desc = "Past over selection", mode = "x" },
      { "<leader>y", '"+y', desc = "[Y]ank to system", mode = { "v", "x" } },
      { "n", "nzzzv", desc = "Next, center, open folds" },
      { "N", "Nzzzv", desc = "Previous center, open folds" },
      { "<C-o>", "<C-o>zz", desc = "Jump back center" },
      { "<C-i>", "<C-i>zz", desc = "Jump forward center" },
      { "Q", "<nop>" },

      { "<leader>dm", d2_diagram, mode = "v", desc = "Diagram Make" },

    })
  end,
}
