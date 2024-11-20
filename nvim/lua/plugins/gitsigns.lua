return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require('gitsigns').setup()
    local wk = require "which-key";
    local gs = require "gitsigns"
    wk.add({
      {
        "<leader>hf",
        function()
          gs.setqflist({
            target = "all"
          })
        end
        ,
        desc = "Populate quickfix with hunks"
      },
      {
        "]h",
        function()
          gs.nav_hunk("next")
        end
        ,
        desc = "Next Hunk"
      },
      -- Navigation
      {
        "[h",
        function()
          gs.nav_hunk("prev")
        end,
        desc = "Prev Hunk"
      },

      -- Actions
      { "<leader>hs", gs.stage_hunk, desc = "Stage hunk" },
      { "<leader>hr", gs.reset_hunk, desc = "Reset hunk" },
      {
        "<leader>hs",
        function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end,
        mode = { "v" },
        desc = "Stage hunk"
      },
      {
        "<leader>hr",
        function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end,
        mode = { "v" },
        desc = "Reset hunk"
      },
      { "<leader>hS", gs.stage_buffer,                               desc = "Stage buffer" },
      { "<leader>hw", gs.word_diff,                                  desc = "Toggle word diff" },
      { "<leader>hR", gs.reset_buffer,                               desc = "Reset buffer" },

      { "<leader>hu", gs.undo_stage_hunk,                            desc = "Undo stage hunk" },

      { "<leader>hp", gs.preview_hunk,                               desc = "Preview hunk" },

      { "<leader>hb", function() gs.blame_line({ full = true }) end, desc = "Blame line" },
      { "<leader>hB", gs.toggle_current_line_blame,                  desc = "Toggle line blame" },
    })
  end
}
