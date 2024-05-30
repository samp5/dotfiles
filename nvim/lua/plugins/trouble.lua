return {
  "folke/trouble.nvim",
  event = { "BufEnter" },
  branch = "dev",
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
    wk.register({
      ['<leader>x'] = {
        name = "Trouble",
        x = { function() tr.toggle({ mode = "diagnostics_buffer" }) end, "Buffer Diagnostics" },
        X = { function() tr.toggle({ mode = "diagnostics" }) end, "Diagnostics" },
        p = { function() tr.toggle({ mode = "buffer_split_preview" }) end, "Buffer Diagnostics Preview" },
        P = { function() tr.toggle({ mode = "split_preview" }) end, "Diagnostics Preview" },
        l = { function() tr.toggle({ mode = "lsp" }) end, "LSP" },
        s = { function() tr.toggle({ mode = "symbols" }) end, "Symbols" },
        q = { function() tr.toggle({ mode = "qflist" }) end, "QuickFix" },
        c = { function() tr.toggle({ mode = "cascade" }) end, "Diagnostics cascade" },
      }

    })
  end
}
