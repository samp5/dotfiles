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
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        lsp = {
          win = { type = "split", position = "left" },
        },
      },
    },
  },
}
