return {
  lazy = false,
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require('kanagawa').setup({
        transparent = true,
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        dimInactive = false,   -- dim inactive window `:h hl-NormalNC`

        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {
          -- add/modify theme and palette colors
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { fg = theme.ui.bg_p2, bg = "none" },
            FloatTitle  = { bg = "none", fg = "none" },
            PmenuSel    = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar   = { bg = theme.ui.bg_m1 },
            PmenuThumb  = { bg = theme.ui.bg_p2 },
          }
        end,

        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = {
          -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus"
        },
      })
    end
  },
}
