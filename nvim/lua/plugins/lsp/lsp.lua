local function get_arduino_cmd()
  local cmds = {
    "arduino-language-server",                                --
    "-cli", "/usr/bin/arduino-cli",                           -- path to arduino-cli
    "-cli-config", "/home/sam/.arduino15/arduino-cli.yaml",   -- path to your arduino-cli config (should be auto generated)
    "-fqbn", "arduino:renesas_uno:unor4wifi",                 -- fully qualified name of your board ( can get with `arduino-cli board list ` at termnial when board is attached)
    "-clangd", "/home/sam/.local/share/nvim/mason/bin/clangd" -- path to clangd
  }
  return cmds
end

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

      vim.lsp.enable({ 'clangd', 'pyright', 'hls', 'rust_analyzer', 'gopls', 'fsautocomplete', 'sqlls', 'lua_ls' })
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
  }
}
