return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        }
      }
    }
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = "williamboman/mason.nvim",
    opts = {
      automatic_installation = true, -- not the same as ensure_installed
      ensure_installed = {
        "pyright",
        "clangd",
        "lua_ls",
        "rust_analyzer",
        "markdown_oxide",
      },
    }
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
    dependencies = "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
      },
    }
  }

}
