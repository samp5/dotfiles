return {
  'willothy/nvim-cokeline',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require "cokeline".setup({
      components = {
        -- {
        --   text = function(buffer) return ' ' .. buffer.index .. ' ' end,
        --   bold = true,
        -- },
        {
          text = function(buffer)
            if buffer.pick_letter ~= string.sub(buffer.filename, 0, 1) then
              return ' (' .. buffer.pick_letter .. ') '
            else
              return ''
            end
          end,
          bold = true,
        },
        {
          text = function(buffer) return ' ' .. buffer.devicon.icon end,
          fg = function(buffer) return buffer.devicon.color end,
        },
        {
          text = function(buffer) return buffer.filename .. ' ' end,
        },
        {
          text = function(buffer) if buffer.diagnostics.errors > 0 then return '   ' else return '' end end,
          -- same red as return statements
          fg = '#f45a60'
        },
        {
          text = function(buffer) if buffer.is_modified then return '󰆓 ' else return '' end end,
        },
        {
          text = ' ',
        }
      },
    })
    local wk = require "which-key"
    wk.add({
      { 'H', '<Plug>(cokeline-focus-prev)', desc = 'Focus previous buffer' },
      { 'L', '<Plug>(cokeline-focus-next)', desc = 'Focus next buffer' },
      { 'X', '<Plug>(cokeline-pick-close)', desc = 'Pick close' },
      {
        "<leader>p",
        function()
          require('cokeline.mappings').pick("focus")
        end,
        desc = "Pick a buffer to focus"
      },
    })
  end
}
