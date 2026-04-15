return {
  "nicolasgb/jj.nvim",
  version = "*", -- Use latest stable release
  -- Or from the main branch (uncomment the branch line and comment the version line)
  -- branch = "main",
  config = function()
    require("jj").setup({})
    local wk = require("which-key")
    local annotate = require("jj.annotate")
    local diff = require('jj.diff')
    local cmd = require("jj.cmd")
    local picker = require("jj.picker")

    wk.add({
      {
        "<leader>j",
        group = "[j]j",
        icon = { icon = "🐦", color = "blue" },
      },

      -- Annotation
      {
        "<leader>jA",
        annotate.file,
        desc = "[A]nnotate File",
      },
      {
        "<leader>ja",
        annotate.line,
        desc = "[a]nnotate Line",
      },

      -- Diff Commands
      {"<leader>jD", cmd.describe,  desc = "jj describe" },
      {
        "<leader>jd",
        group = "[d]iff",
        icon = { icon = "δ", color = "green" },
      },
      {"<leader>jdd", cmd.diff,  desc = "jj diff" },
      {"<leader>jdf", diff.open_vdiff,  desc = "jj diff current buffer" },
      {"<leader>jdF", diff.open_hdiff,  desc = "jj hdiff current buffer" },

      {"<leader>jl", cmd.log,  desc = "jj log" },
      {"<leader>jL", function() cmd.log { revisions = "'all()'"} end,  desc = "jj Log All" },
      {"<leader>je", cmd.edit,  desc = "jj edit" },
      {"<leader>jn", cmd.new, desc = "jj new" },
      {"<leader>jS", cmd.status,  desc = "jj status" },

      {
        "<leader>js",
        group = "[s]earch",
        icon = { icon = " ", color = "yellow" },
      },
      { "<leader>jss", picker.status, desc = "[s]tatus" },
      { "<leader>jsh", picker.file_history,  desc = "[h]istory" }
    })
  end,
}
