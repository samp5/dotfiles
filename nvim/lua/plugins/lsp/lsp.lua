local lsp_on_attach = require 'lspbindings'.lsp_on_attach

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- loads for new files or new buffers
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "SmiteshP/nvim-navic" },
      { "p00f/clangd_extensions.nvim" },
      { "lukas-reineke/lsp-format.nvim" },
    },
    config = function()
      -- import lspconfig plugin
      local lspconfig = require("lspconfig")

      -- Error icons
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local border = {
        { "╭", "FloatBorder" },

        { "─", "FloatBorder" },

        { "╮", "FloatBorder" },

        { "│", "FloatBorder" },

        { "╯", "FloatBorder" },

        { "─", "FloatBorder" },

        { "╰", "FloatBorder" },

        { "│", "FloatBorder" },

      }
      -- Set up handler to include my border characters
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
      }

      local capabilities = require "cmp_nvim_lsp".default_capabilities(vim.lsp.protocol.make_client_capabilities())

      capabilities.workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      }

      require("lspconfig").markdown_oxide.setup({
        capabilities = capabilities, -- again, ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
        on_attach = lsp_on_attach,   -- configure your on attach config
        handlers = handlers,
      })

      lspconfig.clangd.setup {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        handlers = handlers,
        cmd = {
          "clangd",
          "--completion-style=detailed",
          "--clang-tidy",
        },
      }


      -- configure python server
      lspconfig.pyright.setup {
        on_attach = lsp_on_attach,
        handlers = handlers,
        capabilities = capabilities,
      }

      lspconfig.hls.setup {
        on_attach = lsp_on_attach,
        handlers = handlers,
        capabilities = capabilities,
      }

      lspconfig.rust_analyzer.setup {
        on_attach = lsp_on_attach,
        handlers = handlers,
        capabilities = capabilities,
      }

      lspconfig.ts_ls.setup {
        on_attach = lsp_on_attach,
        handlers = handlers,
        capabilities = capabilities,
      }

      -- configure lua server (with special settings)
      lspconfig["lua_ls"].setup({
        on_attach = lsp_on_attach,
        handlers = handlers,
        settings = { -- custom settings for lua
          Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              -- make language server aware of runtime files
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })
    end,
  }
}
