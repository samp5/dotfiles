return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-buffer",           -- source for text in buffer
    "hrsh7th/cmp-path",             -- source for file system paths
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",             -- snippet engine
    "saadparwaiz1/cmp_luasnip",     -- for autocompletion
    "rafamadriz/friendly-snippets", -- useful snippets
    "onsails/lspkind.nvim",         -- vs-code like pictograms
    "kdheepak/cmp-latex-symbols",   --latex for markdown files
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")


    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_snipmate").lazy_load({
      paths = '~/dotfiles/nvim/lua/plugins/snips/snippets/' }
    )
    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noselect,preview",
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-c>"] = cmp.mapping.close(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<CR>"] = cmp.mapping.confirm({
          select = false,
          behavior = cmp.ConfirmBehavior.Replace
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      -- sources for autocompletion
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          option = {
            markdown_oxide = {
              keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
            }
          }
        },
        { name = "luasnip" }, -- snippets
        { name = "buffer" },  -- text within current buffer
        { name = "path" },    -- file system paths
        { name = "nvim_lsp_signature_help" },
      }),

      sorting = {
        comparators = {
          require('clangd_extensions.cmp_scores'),
        },
      },

      cmp.setup.filetype('markdown', {
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            option = {
              markdown_oxide = {
                keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
              }
            }
          },
          { name = "luasnip" }, -- snippets
          { name = "buffer" },  -- text within current buffer
          { name = "path" },    -- file system paths
        }),

        -- configure lspkind for vs-code like pictograms
        formatting = {
          format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        window = {
          documentation = cmp.config.window.bordered(),
          completion = cmp.config.window.bordered(),
        }
      })
    })
  end,
}
