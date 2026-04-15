local function add_cpp_keymaps(bufnr)
  local wk = require("which-key")

  wk.add({
    "<leader>cD",
    require("cpp_utils").cppman_type_under_cursor,
    desc = "cppman for type under cursor",
    buffer = bufnr,
  })

  wk.add({
    "<leader>f=",
    require("cpp_utils").cppman_picker,
    desc = "Search cppman pages",
    buffer = bufnr,
  })

end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if client and client.name == "clangd" then
      add_cpp_keymaps(bufnr)
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_markers = {
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac", -- AutoTools
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja",
            ".git",
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--all-scopes-completion",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
            fallbackFlags = { "--std=c++20" },
          },
        },
      },
    },
  },
}
