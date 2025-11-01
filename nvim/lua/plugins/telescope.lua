return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-lua/plenary.nvim",
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      local open_with_trouble = require 'trouble.sources.telescope'.open
      local actions = require 'telescope.actions'
      require('telescope').setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--multiline",
          },
          layout_strategy = "flex",
          selection_caret = ' ',
          prompt_prefix = ' ',
          multi_icon = ' ',
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
            },
            n = { ["<c-t>"] = open_with_trouble },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        },
      })


      local tele = require 'telescope.builtin'
      local wk = require 'which-key'
      local ic = require 'mini.icons'
      local theme = require 'telescope.themes'
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
          icon = { icon = "󰮗", color = "blue" }
        },
        {
          "<leader>fd",
          tele.diagnostics,
          desc = "Diagnostics",
          icon = { icon = "", color = "red" }
        },
        {
          "<leader>ff",
          function()
            tele.find_files(
              theme.get_dropdown {
                previewer = false,
              }
            )
          end,
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
          icon = { icon = ic.get('lsp', 'color'), color = "yellow" }
        },
        {
          "<leader>fm",
          function()
            tele.man_pages({ sections = { "1", "2", "3", "7" } })
          end,
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
          function()
            tele.buffers(
              theme.get_dropdown {
                previewer = false,
              }
            )
          end,
          desc = "Buffers",
          icon = { icon = "", color = "blue" }
        },
        {
          "<leader>fj",
          function()
            tele.jumplist(
              theme.get_dropdown {
                previewer = true,
              }
            )
          end,
          desc = "Jumplist",
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
          icon = { icon = "", color = "yellow" }
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
