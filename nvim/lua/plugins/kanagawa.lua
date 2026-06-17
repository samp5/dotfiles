return {
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        transparent = true,
        commentStyle = { dim = false, italic = false },
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { fg = theme.ui.bg_p2, bg = "none" },
            NoiceCmdlinePopupBorder = { fg = theme.ui.bg_p2, bg = "none" },
            NoiceCmdlinePopupTitleCmdLine = { fg = theme.ui.fg, bg = "none" },
            NoiceCmdlinePrompt = { bg = "none" },
            Pmenu = { fg = theme.ui.shade0, bg = "none", blend = vim.o.pumblend },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = "none" },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = "none" },
            TelescopePreviewNormal = { bg = "none" },
          }
        end,
        colors = {
          theme = {
            all = {
              ui = {
                -- bg_gutter = "none",
              },
            },
          },
        },
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
