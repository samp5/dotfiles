return {
  lazy = true,
  "catppuccin/nvim",
  name = "catppuccin",
  config = function()
    require("catppuccin").setup({
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = {    -- :h background
        light = "latte",
        dark = "mocha",
      },
      term_colors = false,  -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = true,     -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15,  -- percentage of the shade to apply to the inactive window
      },
      no_italic = true,     -- Force no italic
      no_bold = false,      -- Force no bold
      no_underline = false, -- Force no underline
      default_integrations = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
      },
    })
  end
}
