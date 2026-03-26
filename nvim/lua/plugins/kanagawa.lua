return {
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        transparent = true,
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`

        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { fg = theme.ui.bg_p2, bg = "none" },
          }
        end,

        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = {
          -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
        },
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
