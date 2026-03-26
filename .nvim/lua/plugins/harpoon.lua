return {
  "ThePrimeagen/harpoon",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- loads for new files or new buffers,
  dependencies = { "nvim-lua/plenary.nvim" },

  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")


    local wk = require "which-key"

    wk.add({
      { "<M-o>", ui.toggle_quick_menu,         desc = " Toggle Harpoon Menu" },
      { "<M-p>", mark.add_file,                desc = "Add file to harpoon" },
      { "<C-b>", function() ui.nav_file(1) end },
      { "<C-n>", function() ui.nav_file(2) end },
      { "<C-m>", function() ui.nav_file(3) end },
    })
  end,
}
