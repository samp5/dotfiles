local on_attach = function(ev)
  local client_id = vim.lsp.get_client_by_id(ev.data.client_id)
  require 'nvim-navic'.attach(client_id, ev.buf)

  -- This is to prevent the annoying rust analyzer issue that neovim doesn't handle well
  -- Sometimes (usually when typing fast) the rust-analyzer repeatedly sends a
  -- -32802 server cancelled request error (probably some debounce thing) which just
  -- spams my notifier with big red X-s ...
  -- https://github.com/neovim/neovim/issues/30985 this issue is tracking it
  for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
      if err ~= nil and err.code == -32802 then
        return
      end
      return default_diagnostic_handler(err, result, context, config)
    end
  end

  local tele = require "telescope.builtin"
  local wk = require "which-key"

  wk.add(
    {
      { "<C-h>",      vim.lsp.buf.signature_help, buffer = ev.buf, desc = "Signature help", mode = "i" },
      { "<leader>a",  vim.lsp.buf.code_action,    buffer = ev.buf, desc = "Code action",    mode = { "n", "v" } },
      { "<leader>ic", tele.lsp_incoming_calls,    buffer = ev.buf, desc = "Incoming calls" },
      {
        "<leader>ih",
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end,
        buffer = ev.buf,
        desc = "Toggle inlay hints"
      },
      { "]d",         function() vim.diagnostic.jump({ count = 1, float = true }) end },
      { "[d",         function() vim.diagnostic.jump({ count = -1, float = true }) end },
      { "<leader>sn", vim.lsp.buf.rename,                                              buffer = ev.buf, desc = "Rename" },
      { "<leader>vd", vim.diagnostic.open_float,                                       buffer = ev.buf, desc = "Open diagnostic float" },
      { "<leader>wf", vim.lsp.buf.format,                                              buffer = ev.buf, desc = "Buffer Format",        mode = { "v", "n" } },
      { "K",          vim.lsp.buf.hover,                                               buffer = ev.buf, desc = "Hover" },
      { "gD",         vim.lsp.buf.declaration,                                         buffer = ev.buf, desc = "Go to declaration" },
      { "gd",         tele.lsp_definitions,                                            buffer = ev.buf, desc = "Go to definition" },
      { "gt",         tele.lsp_type_definitions,                                       buffer = ev.buf, desc = "Go type defintion" },
      { "gi",         tele.lsp_implementations,                                        buffer = ev.buf, desc = "Go implementations" },
      { "gr",         tele.lsp_references,                                             buffer = ev.buf, desc = "Go references" },
    })
end


return {
  on_attach = on_attach
}
