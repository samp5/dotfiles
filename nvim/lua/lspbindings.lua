local lsp_on_attach = function(client, bufnr)
  vim.notify("on attach called", vim.log.levels.INFO)
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
        { "<C-h>",      vim.lsp.buf.signature_help, buffer = ev.buf, desc = "Signature help", mode = "i" },
        { "<leader>a",  vim.lsp.buf.code_action,    buffer = ev.buf, desc = "Code action",    mode = { "n", "v" } },
        { "<leader>ic", vim.lsp.buf.incoming_calls, buffer = ev.buf, desc = "Incoming calls" },
        {
          "<leader>ih",
          function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
          end,
          buffer = ev.buf,
          desc = "Toggle inlay hints"
        },
        { "]d",         vim.diagnostic.goto_next },
        { "[d",         vim.diagnostic.goto_prev },
        { "<leader>sn", vim.lsp.buf.rename,                                                      buffer = ev.buf, desc = "Rename" },
        { "<leader>vd", vim.diagnostic.open_float,                                               buffer = ev.buf, desc = "Open diagnostic float" },
        { "<leader>wf", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, buffer = ev.buf, desc = "show workspace folders" },
        { "<space>D",   vim.lsp.buf.type_definition,                                             buffer = ev.buf, desc = "Type definition" },
        { "K",          vim.lsp.buf.hover,                                                       buffer = ev.buf, desc = "Hover" },
        { "gD",         vim.lsp.buf.declaration,                                                 buffer = ev.buf, desc = "Go to declaration" },
        { "gd",         vim.lsp.buf.definition,                                                  buffer = ev.buf, desc = "Go to definition" },
        { "gi",         tele.lsp_implementations,                                                buffer = ev.buf, desc = "Go implementations" },
        { "gr",         tele.lsp_references,                                                     buffer = ev.buf, desc = "Go references" },
        { "<leader>bf", vim.lsp.buf.format,                                                      buffer = ev.buf, desc = "Buffer Format" },
      })
  end
})

return {
  lsp_on_attach = lsp_on_attach,
}
