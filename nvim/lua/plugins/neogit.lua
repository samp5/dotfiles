return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    local wk = require("which-key")
    wk.register({

      ["<leader>n"] = {
        name = "[N]eogit",
        o = { "<cmd>Neogit<CR>", "Open Neogit" }
      }
    })
    require("neogit").setup({
      graph_style = "unicode",
      signs = {
        hunk = { "", "" },
        item = { "", "" },
        section = { "", "" },
      },
      disable_line_numbers = false,
    })
  end

}
