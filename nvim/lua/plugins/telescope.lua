local nnoremap = require "maps".nnoremap

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { "nvim-telescope/telescope-ui-select.nvim", "nvim-lua/plenary.nvim" },

    config = function()
      local open_with_trouble = require 'trouble.sources.telescope'.open
      require('telescope').setup({
        defaults = {
          mappings = {
            i = { ["<c-t>"] = open_with_trouble },
            n = { ["<c-t>"] = open_with_trouble },
          }
        }
      })

      local tele = require 'telescope.builtin'
      local tele_u = require 'telescope.utils'
      local wk = require 'which-key'
      wk.register({
        ["<leader>f"] = {
          name = "[F]ind",
          c = { tele.current_buffer_fuzzy_find, "FF Current Buffer" },
          d = { tele.diagnostics, "Diagnostics" },
          f = { tele.find_files, "Find files" },
          g = {
            name = '[G]it',
            b = { tele.git_bcommits, "Buffer commits" },
            s = { tele.git_stash, "Stash" },
            c = { tele.git_commits, "Commits" },
          },
          h = { tele.help_tags, "Help tags" },
          l = { function()
            tele.colorscheme()
          end, "Colorscheme" },
          m = { tele.man_pages, "Man pages" },
          n = { function() tele.find_files({ cwd = "~/obsidian/SCHOOL/" }) end, "Find note" },
          p = { tele.planets, "Planets" },
          q = { tele.quickfix, "Quickfix" },
          r = { tele.resume, "Resume search" },
          s = { function() tele.live_grep({ cwd = tele_u.buffer_dir() }) end, "Live Grep" },
          u = {
            name = '[U]nder cursor',
            s = { function() tele.grep_string() end, "Grep" }
          },
          w = { tele.treesitter, "Workspace symbols" },
        }
      })
    end
  },
}
