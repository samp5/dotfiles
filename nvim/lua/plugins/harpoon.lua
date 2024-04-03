return {
  "ThePrimeagen/harpoon",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- loads for new files or new buffers,
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = 'Harpoon mark file', noremap = true })
    vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu, { desc = 'Harpoon Menu', noremap = true })

    vim.keymap.set("n", "<C-b>", function() ui.nav_file(1) end, { noremap = true })
    vim.keymap.set("n", "<C-n>", function() ui.nav_file(2) end, { noremap = true })
    vim.keymap.set("n", "<C-m>", function() ui.nav_file(3) end, { noremap = true })
  end,
}
