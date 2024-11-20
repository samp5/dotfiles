return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      extensions = { 'nvim-tree' },
      sections = {
        lualine_c = { "navic" },
        lualine_x = { 'encoding', 'filetype' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { 'branch', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'filetype' },
        lualine_z = { 'location' }
      },
    })
  end
}
