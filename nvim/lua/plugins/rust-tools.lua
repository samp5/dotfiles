return {
  'mrcjkb/rustaceanvim',
  version = '^6', -- Recommended
  lazy = false,   -- This plugin is already lazy
  config = function()
    local wk = require 'which-key'

    wk.add {
      {
        "<leader>r",
        group = "[r]ust tools",
        icon = { icon = "󱘗 ", color = "orange" }
      },
      {
        "<leader>rd",
        function()
          vim.cmd.RustLsp('openDocs')
        end,
        group = "[d]ocs for symbol under cursor",
        icon = { icon = "󱪝", color = "blue" }
      },
      {
        "<leader>rr",
        function()
          vim.cmd.RustLsp('openDocs')
        end,
        group = "[r]ender diagnostic",
        icon = { icon = "󱪝", color = "blue" }
      },
      {
        "<leader>rm",
        function()
          vim.cmd.RustLsp('openDocs')
        end,
        group = "[m]acro expand",
        icon = { icon = "󰵏 ", color = "green" }
      },
      {
        "<leader>rm",
        function()
          vim.cmd.RustLsp('openDocs')
        end,
        group = "[m]acro expand",
        icon = { icon = "󰵏 ", color = "green" }
      },
      {
        "<leader>rp",
        function()
          vim.cmd.RustLsp('parentModule')
        end,
        group = "[p]arent module",
        icon = { icon = "󰕳 ", color = "purple" }
      },
    }

    vim.g.rustaceanvim = {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              features = "all",
            }
          },
        }
      }
    }
  end
}
