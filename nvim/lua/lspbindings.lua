local lsp_on_attach = function(client, bufnr)
  require 'nvim-navic'.attach(client, bufnr)
  require "lsp-format".on_attach(client)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local tele = require("telescope.builtin")
    local troub_t = require "trouble.sources.telescope"
    local wk = require "which-key"

    wk.add(
      {
        { "<C-h>",      vim.lsp.buf.signature_help, buffer = ev.buf, desc = "Signature help", mode = "i",          group = "LSP" },
        { "<leader>a",  vim.lsp.buf.code_action,    buffer = ev.buf, desc = "Code action",    mode = { "n", "v" }, group = "LSP" },
        { "<leader>ic", vim.lsp.buf.incoming_calls, buffer = ev.buf, desc = "Incoming calls" },
        {
          "<leader>ih",
          function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
          end,
          buffer = ev.buf,
          desc = "Toggle inlay hints"
          ,
          group = "LSP"
        },
        { "]d",         vim.diagnostic.goto_next,                                                group = "LSP" },
        { "[d",         vim.diagnostic.goto_prev,                                                group = "LSP" },
        { "<leader>sn", vim.lsp.buf.rename,                                                      buffer = ev.buf, desc = "Rename",                 group = "LSP" },
        { "<leader>vd", vim.diagnostic.open_float,                                               buffer = ev.buf, desc = "Open diagnostic float",  group = "LSP" },
        { "<leader>wf", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, buffer = ev.buf, desc = "show workspace folders", group = "LSP" },
        { "<space>D",   vim.lsp.buf.type_definition,                                             buffer = ev.buf, desc = "Type definition",        group = "LSP" },
        { "K",          vim.lsp.buf.hover,                                                       buffer = ev.buf, desc = "Hover",                  group = "LSP" },
        { "gD",         vim.lsp.buf.declaration,                                                 buffer = ev.buf, desc = "Go to declaration",      group = "LSP" },
        { "gd",         vim.lsp.buf.definition,                                                  buffer = ev.buf, desc = "Go to definition",       group = "LSP" },
        { "gi",         tele.lsp_implementations,                                                buffer = ev.buf, desc = "Go implementations",     group = "LSP" },
        { "gr",         tele.lsp_references,                                                     buffer = ev.buf, desc = "Go references",          group = "LSP" },
        { "<leader>bf", vim.lsp.buf.format,                                                      buffer = ev.buf, desc = "Buffer Format",          group = "LSP" },
      })
  end
})

return {
  lsp_on_attach = lsp_on_attach
}
