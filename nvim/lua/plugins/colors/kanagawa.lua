return {
  lazy = false,
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require('kanagawa').setup({
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
        transparent = true,
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = {
          -- add/modify theme and palette colors
          palette = {
            -- change background color
            -- sumiInk6 = "#54546D",
            -- change line number, etc color
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat                  = { bg = "none" },
            FloatBorder                  = { bg = "none" },
            FloatTitle                   = { bg = "none" },
            -- TelescopeTitle               = { fg = theme.ui.special, bold = true },
            -- TelescopePromptNormal        = { bg = theme.ui.bg_p1 },
            -- TelescopePromptBorder        = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            -- TelescopeResultsNormal       = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            -- TelescopeResultsBorder       = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            -- TelescopePreviewNormal       = { bg = theme.ui.bg_dim },
            -- TelescopePreviewBorder       = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
            Pmenu                        = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel                     = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar                    = { bg = theme.ui.bg_m1 },
            PmenuThumb                   = { bg = theme.ui.bg_p2 },
            --
            NeogitBranch                 = { fg = theme.syn.keyword },
            NeogitBranchHead             = { fg = theme.syn.statement },
            NeogitSectionHeader          = { fg = theme.syn.parameter },
            NeogitDiffDelete             = { fg = theme.diff.add },
            NeogitDiffHeader             = { fg = theme.ui.fg, bg = theme.ui.bg_m3 },
            NeogitChangeModified         = { fg = theme.syn.preproc },
            NeogitCommitViewHeader       = { fg = theme.ui.fg, bg = theme.ui.bg_m4 },

            NeogitPopupConfigKey         = { fg = theme.diff.text },
            NeogitPopupActionKey         = { fg = theme.syn.regex },

            NeogitPopupSwitchKey         = { fg = theme.diag.hint },
            NeogitPopupSwitchKeyEnabled  = { fg = theme.diag.ok },
            NeogitPopupSwitchKeyDisabled = { fg = theme.diag.warning },

            NeogitPopupOptionKey         = { fg = theme.diag.hint },
            NeogitPopupOptionKeyEnabled  = { fg = theme.diag.ok },
            NeogitPopupOptionKeyDisabled = { fg = theme.diag.warning },
            CursorLineNr                 = { fg = theme.ui.fg }
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
