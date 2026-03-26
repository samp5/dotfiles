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
      -- Error icons
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      vim.lsp.config("ts_ls", {
        root_dir = vim.fs.dirname(vim.fs.find({ 'tsconfig.json', 'package.json' }, { upward = true })[1]),
      })

      vim.lsp.config("nil", {
        cmd ={'nil'},
        filetypes = {'nix'},
        root_markers = {'flake.nix', '.git'}
      })

      vim.lsp.config("tinymist", {
        settings = {
          formatterMode = "typstyle"
        }
      })

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
        'clangd',
        'cssls',
        'fsautocomplete',
        'gopls',
        'hls',
        "nil",
        'html',
        'lua_ls',
        'pyright',
        'ruff',
        'sqlls',
        'ts_ls',
        'tinymist',
        'asm_lsp',
      })
    end,
  },
}
