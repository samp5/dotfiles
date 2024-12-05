return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- change color to mauve
    vim.cmd([[ highlight NvimTreeOpenedHL guifg=#A0A07A ]])

    -- configure nvim-tree
    nvimtree.setup({
      view = {
        relativenumber = false,
        side = "right",
      },
      -- change folder arrow icons
      renderer = {
        highlight_opened_files = "name",
        indent_markers = {
          enable = true,
        },
      },
      filters = {
        git_ignored = false,
      },
      git = {
        ignore = true,
      },
    })

    -- set keymaps
    local t = require "nvim-tree.api"
    local wk = require "which-key"

    wk.add({
      { "<leader>e",  group = "Fil[E] Exploxer" },
      { "<leader>ed", t.tree.toggle,            desc = "Open file explorer" },
      { "<leader>ef", t.tree.focus,             desc = "Float file explorer" },
      { "<leader>er", t.tree.reload,            desc = "Reload file explorer" },
      {
        "<leader>eb",
        function()
          t.tree.find_file({
            update_root = "!", open = true, focus = true
          })
        end,
        desc = "Focus the current buffer"
      },
    })
  end,
}
