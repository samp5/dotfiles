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

      vim.lsp.enable({
        'clangd',
        'cssls',
        'fsautocomplete',
        'gopls',
        'hls',
        'html',
        'lua_ls',
        'pyright',
        'ruff',
        'sqlls',
        'ts_ls',
        'tinymist',
        'jdtls',
        'asm_lsp',
      })
      vim.lsp.config("ts_ls", {
        root_dir = vim.fs.dirname(vim.fs.find({'tsconfig.json', 'package.json'}, { upward = true })[1]),
      })
      vim.lsp.config("jdtls", {
        settings = {
          java = {
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            inlayHints = {
              enabled = true,
              parameterNames = {
                enabled = 'all' -- literals, all, none
              }
            },
            format = {
              enabled = true,
            }
          },
          signatureHelp = {
            enabled = true,
          },
          contentProvider = {
            preferred = 'fernflower',
          },
          extendedClientCapabilities = require'jdtls'.extendedClientCapabilities,
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            }
          },
          codeGeneration = {
            toString = {
              template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
            },
            useBlocks = true,
          }
        },
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
    end,
  },
}
