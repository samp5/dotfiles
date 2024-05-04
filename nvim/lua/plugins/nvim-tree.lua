return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- change color for arrows in tree to light blue
    vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
    vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

    -- change color to mauve
    vim.cmd([[ highlight NvimTreeOpenedHL guifg=#A0A07A ]])

    -- configure nvim-tree
    nvimtree.setup({
      hijack_cursor = true,
      view = {
        width = 35,
        relativenumber = true,
        float = {
          -- can't decide if I like this?
          -- enable = true,
        },
      },
      -- change folder arrow icons
      renderer = {
        highlight_opened_files = "name",
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "", -- arrow when folder is closed
              arrow_open = "", -- arrow when folder is open
            },
          },
        },
      },
      filters = {
        git_ignored = false,
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        }
      },
      git = {
        ignore = true,
      },
    })

    -- set keymaps
    local wk = require 'which-key'

    wk.register({
      ['<leader>e'] = {
        name = "Fil[E] Exploxer",
        e = { "<cmd>NvimTreeToggle<CR>", "Toggle file explorer" },
        f = { "<cmd>NvimTreeFocus<CR>", "Focus file explorer" },
        r = { "<cmd>NvimTreeRefresh<CR>", "Refresh file explorer" },
      }
    })
  end,
}
