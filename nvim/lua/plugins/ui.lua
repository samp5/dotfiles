return {
  {
    "snacks.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>E", false },
    },
    opts = {
      scroll = { enabled = false },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      words = { enabled = false },
      notifier = { enabled = false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      autoformat = false,
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = true,
        },
      },
    },
  },
  { "folke/noice.nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      extensions = { "nvim-tree", "trouble", "man", "mason", "nvim-dap-ui" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "navic" },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = { "bo:filetype", "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_z = { "location" },
      },
    },
  },
}
