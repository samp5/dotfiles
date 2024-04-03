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
    local keymap = vim
        .keymap                                                                                   -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })   -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>",
      { desc = "Open file tee if it is closed and focus on explorer" })                           -- toggle file explorer on current file
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
  end,
}
