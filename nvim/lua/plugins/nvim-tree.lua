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
        relativenumber = true,
        float = {
          -- can't decide if I like this?
          enable = true,
          open_win_config = {
            relative = "editor",
            col = math.floor((vim.o.columns - 30) / 2),
            row = math.floor((vim.o.lines - 30) / 2),


            -- line = math.floor(((vim.o.lines - height) / 2) - 1),
            -- col = math.floor((vim.o.columns - width) / 2),
          }
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
    local t = require "nvim-tree.api"
    local wk = require "which-key"

    wk.register({
      ['<leader>e'] = {
        name = "Fil[E] Exploxer",
        e = { t.tree.toggle, "Open file explorer" },
        f = { t.tree.toggle, "Float file explorer" },
        r = { t.tree.reload, "Reload file explorer" },
      }
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*NvimTree*" },
      callback = function(buf)
        vim.api.nvim_buf_set_keymap(buf, "n", "q", ":lua require'nvim-tree.api'.tree.toggle()", {})
      end
    })
  end,
}
