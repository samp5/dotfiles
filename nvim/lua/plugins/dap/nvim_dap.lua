return {
  'mfussenegger/nvim-dap',
  lazy = true,
  event = "VeryLazy",
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      ensure_installed = {
        "codelldb",
        "java-debug-adapter",
      },
      handlers = {},
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>be', dapui.eval, { desc = 'Debug: Evaluate' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- vim.keymap.set('n', '<leader>dwa', dapui.elements.watches.add, { desc = '[D]ebug: [W]atch [A]dd' })
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = '', linehl = '', numhl = '' })
    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" }
        }
      },
      icons = { expanded = '', collapsed = '', current_frame = '' },
      controls = {

        element = "console",
        icons = {
          pause = "",
          play = '▶',
          step_into = '',
          step_over = '',
          step_out = '',
          step_back = '',
          terminate = '',
          disconnect = '',
        },
      },
      layouts = { {
        elements = { {
          id = "scopes",
          size = 0.2
        }, {
          id = "breakpoints",
          size = 0.2,
          mappings = {
            open = { "g" },
            toggle = { "t" },
          }
        }, {
          id = "stacks",
          size = 0.2,
          mappings = {
            open = { "g" },
          }
        }, {
          id = "watches",
          size = 0.2,
          mappings = {
            remove = { "x" },
            edit = { "e" },
            repl = { "l" },
          }
        }, {
          id = "hover",
          size = 0.2
        } },
        position = "left",
        size = 10
      }, {
        elements = { {
          id = "console",
          size = 0.5
        } },
        position = "bottom",
        size = 10
      } },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.configurations.java = {
      {
        type = 'java',
        request = 'launch',
        name = 'Launch Java Program'
      }

    }
  end,
}
