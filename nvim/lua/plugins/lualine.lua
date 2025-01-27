local function arduino_status()
  if vim.bo.filetype ~= "arduino" then
    return ""
  end
  local port = vim.fn["arduino#GetPort"]()
  local line = string.format(" %s ", vim.g.arduino_board)
  if port ~= 0 then
    line = line .. string.format("󱇰 %s:%s", port, vim.g.arduino_serial_baud)
  else
    line = line .. "󱘖 No Port"
  end
  return line
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      theme = 'auto',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
    extensions = { 'nvim-tree', 'trouble', 'man', 'mason', 'nvim-dap-ui' },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { "navic" },
      lualine_x = { arduino_status, 'encoding', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    },
    inactive_sections = {
      lualine_a = { 'bo:filetype', 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_z = { 'location' }
    },
  }
}
