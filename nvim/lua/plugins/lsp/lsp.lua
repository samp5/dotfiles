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


      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- configure c++ server
      lspconfig.clangd.setup {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        cmd = {
          "clangd",
          "--completion-style=detailed",
          "--clang-tidy",
        },
      }


      -- configure python server
      lspconfig.pyright.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      lspconfig.rust_analyzer.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      -- configure lua server (with special settings)
      lspconfig["lua_ls"].setup({
        on_attach = lsp_on_attach,
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
