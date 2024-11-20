return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { "nvim-telescope/telescope-ui-select.nvim", "nvim-lua/plenary.nvim" },

    config = function()
      local open_with_trouble = require 'trouble.sources.telescope'.open
      require('telescope').setup({
        defaults = {
          layout_strategy = "flex",
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<C-j>"] = require('telescope.actions').move_selection_next,
              ["<C-k>"] = require('telescope.actions').move_selection_previous,
              ["<C-d>"] = require('telescope.actions').preview_scrolling_down,
              ["<C-u>"] = require('telescope.actions').preview_scrolling_up,
            },
            n = { ["<c-t>"] = open_with_trouble },
          },
        }
      })

      local tele = require 'telescope.builtin'
      local wk = require('which-key')
      local ic = require('mini.icons')
      wk.add({
        {
          "<leader>f",
          group = "[F]ind",
          icon = { icon = "", color = "blue" }
        },
        {
          "<leader>fc",
          tele.current_buffer_fuzzy_find,
          desc = "FF Current Buffer",
          icon = { icon = "󰮗", color = "red" }
        },
        {
          "<leader>fd",
          tele.diagnostics,
          desc = "Diagnostics",
          icon = { icon = "", color = "red" }
        },
        {
          "<leader>ff",
          tele.find_files,
          desc = "Find files",
          icon = { icon = '󰈞', color = "blue" }

        },
        {
          "<leader>fh",
          tele.help_tags,
          desc = "Help tags",
          icon = { icon = '', color = "blue" }
        },
        {
          "<leader>fl",
          tele.colorscheme,
          desc = "Colorscheme",
          icon = { icon = ic.get('lsp', 'color'), color = "blue" }
        },
        {
          "<leader>fm",
          tele.man_pages,
          desc = "Man pages",
          icon = { icon = ic.get('filetype', 'help'), color = "blue" }
        },
        {
          "<leader>fr",
          tele.resume,
          desc = "Resume search",
          icon = { icon = "", color = "blue" }
        },
        {
          "<leader>fs",
          tele.live_grep,
          desc = "Live Grep",
          icon = { icon = "", color = "blue" }

        },
        {
          "<leader>fw",
          tele.treesitter,
          desc = "Workspace Symbols",
          icon = { icon = ic.get('lsp', 'class'), color = "blue" }
        },
        {
          "<leader>fb",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
          desc = "Buffers",
          icon = { icon = "", color = "blue" }
        },

        { "<leader>fg", group = "[G]it", icon = { icon = "", color = "blue" } },
        {
          "<leader>fgb",
          tele.git_bcommits,
          desc = "Buffer commits",
          icon = { icon = "", color = "blue" }
        },
        {
          "<leader>fgc",
          tele.git_commits,
          desc = "Commits",
          icon = { icon = "", color = "blue" }
        },
        {
          "<leader>fgs",
          tele.git_stash,
          desc = "Stash",
          icon = { icon = "", color = "blue" }
        },
        {
          '<leader>fgo',
          function()
            local git_icons = {
              added = "",
              changed = "󰜥",
              copied = "",
              deleted = "",
              renamed = "󱀱",
              unmerged = "‡",
              untracked = "",
            }
            tele.git_status({
              git_icons = git_icons,
            })
          end,
          desc = "Status",
          icon = { icon = "󱖫", color = "green" }
        },
      })
    end
  },
}
