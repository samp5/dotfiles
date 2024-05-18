local lsp_on_attach = function(client, bufnr)
  require 'nvim-navic'.attach(client, bufnr)
  require "lsp-format".on_attach(client)

  vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
end


vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local tele = require("telescope.builtin")
    local troub_t = require "trouble.sources.telescope"
    local wk = require "which-key"

    wk.register({
      ["K"] = { vim.lsp.buf.hover, "Hover", buffer = ev.buf },
      ["<C-h>"] = { mode = 'i', vim.lsp.buf.signature_help, "Signature help", buffer = ev.buf },
      ["<leader>sh"] = { vim.lsp.buf.signature_help, "Signature help", buffer = ev.buf },
      ['gd'] = { vim.lsp.buf.definition, "Go to definition", buffer = ev.buf },
      ['gD'] = { vim.lsp.buf.declaration, "Go to declaration", buffer = ev.buf },
      ['<space>D'] = { vim.lsp.buf.type_definition, "Type definition", buffer = ev.buf },
      ['gr'] = { tele.lsp_references, "Go references", buffer = ev.buf },
      ['gi'] = { tele.lsp_implementations, "Go implementations", buffer = ev.buf },
      ['<leader>ic'] = { tele.lsp_incoming_calls, "Incoming calls", buffer = ev.buf },
      ['<leader>sn'] = { vim.lsp.buf.rename, "Rename", buffer = ev.buf },
      ['<leader>a'] = { mode = { 'n', 'v' }, vim.lsp.buf.code_action, "Code action", buffer = ev.buf },
      ['<leader>ih'] = { function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, "Toggle inlay hints", buffer = ev.buf },
      ['<leader>wf'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "show workspace folders", buffer = ev.buf }
    })
  end
})

return {
  lsp_on_attach = lsp_on_attach
}
