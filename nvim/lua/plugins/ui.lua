return {
  {
    "bufferline.nvim",
    opts = {
      options = {
        highlights = {
          fill = {
            bg = {
              attribute = "fg",
              highlight = "Pmenu",
            },
          },
        },
      },
    },
  },
  {
    "snacks.nvim",
    keys = {
      { "<leader>e", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>E", false },
    },
    opts = {
      scroll = { enabled = true },
      dashboard = {
        preset = {
          header = [[
░█░░░░█▀▀░█░░█░░▄▀▀▄░░░█▀▀▀░█▀▀▄░█░▒█░█▀▀▀
░█▀▀█░█▀▀░█░░█░░█░░█░░░█░▀▄░█▄▄▀░█░▒█░█░▀▄
░▀░░▀░▀▀▀░▀▀░▀▀░░▀▀░░░░▀▀▀▀░▀░▀▀░░▀▀▀░▀▀▀▀
        ]],
        },
      },
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
  {
    "folke/noice.nvim",
    enabled = true,
    opts = {
      routes = { { view = "notify", filter = { event = "msg_showmode" } } },
      views = {
        cmdline_popup = {
          border = {
            style = "single",
            padding = { 0, 0 },
          },
          filter_options = {},
          win_options = {
            winhighlight = {
              Normal = "NoicePopup",
              FloatTitle = "NoiceCmdlinePopupTitle",
              FloatBorder = "NoicePopupBorder",
              IncSearch = "",
              CurSearch = "",
              Search = "",
            },
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      extensions = { "nvim-tree", "trouble", "man", "mason", "nvim-dap-ui" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "navic" },
        lualine_x = {
          "encoding",
          "filetype",
          {
            require("noice").api.statusline.mode.get,
            cond = require("noice").api.statusline.mode.has,
            color = { fg = "#ff9e64" },
          },
        },
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
