return {
  -- Mason
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim",
    dependencies = "williamboman/mason.nvim",
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "clangd", "jdtls",         "lua_ls",
        "gopls",  "rust_analyzer", "ts_ls"
      },
    },
    config = function()
      -- ensures that mason is set up before mason-lspconfig
      require 'mason'.setup({})
      require 'mason-lspconfig'.setup({})
    end
  },
  { "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.config('lua_ls', {
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
      vim.lsp.enable({
	"lua_ls"
      })
    end
  }
}

