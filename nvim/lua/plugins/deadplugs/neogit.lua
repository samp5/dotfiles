return {
  "NeogitOrg/neogit",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
  },
  config = function()
    local wk = require("which-key")
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
