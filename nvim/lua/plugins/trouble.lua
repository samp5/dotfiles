return {
  "folke/trouble.nvim",
  event = { "BufEnter" },
  config = function()
    require 'trouble'.setup({
      modes = {
        buffer_split_preview = {
          auto_close = true,
          mode = "diagnostics",
          filter = { buf = 0 },
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
        split_preview = {
          auto_close = true,
          mode = "diagnostics",
          preview = {
            type = "split",
            relative = "win",
            position = "right",
            size = 0.3,
          },
        },
        cascade = {
          mode = "diagnostics",
          filter = function(items)
            local severity = vim.diagnostic.severity.HINT
            for _, item in ipairs(items) do
              severity = math.min(severity, item.severity)
            end
            return vim.tbl_filter(function(item)
              return item.severity == severity
            end, items)
          end,
        },
        lsp = {
          mode = "lsp",
          win = {
            position = "right",
            size = 0.5
          },
          preview = {
            type = "split",
            relative = "win",
            position = "bottom",
            size = 0.5,
          },
        },
        lsp_ref = {
          mode = "lsp_references",
          win = {
            position = "right",
            size = 0.5
          },
          preview = {
            type = "split",
            relative = "win",
            position = "bottom",
            size = 0.5,
          },
        },
        diagnostics_buffer = {
          mode = "diagnostics", -- inherit from diagnostics mode
          filter = { buf = 0 }, -- filter diagnostics to the current buffer
        },
      },
    })

    local wk = require 'which-key'
    local tr = require 'trouble'
    wk.add({
      { "<leader>x", group = "Trouble" },
      {
        "<leader>xl",
        function() tr.toggle({ mode = "lsp" }) end
        ,
        desc = "LSP"
      },
      {
        "<leader>xp",
        function() tr.toggle({ mode = "buffer_split_preview" }) end
        ,
        desc = "Buffer Diagnostics Preview"
      },

      {
        "<leader>xq",
        function()
          vim.cmd('close')
          tr.toggle({ mode = "qflist" })
        end
        ,
        desc = "QuickFix"
      },
      {
        "<leader>xs",
        function() tr.toggle({ mode = "symbols" }) end
        ,
        desc = "Symbols"
      },
      {
        "<leader>xx",
        function() tr.toggle({ mode = "diagnostics" }) end
        ,
        desc = "Buffer Diagnostics"
      },
    })
  end
}
