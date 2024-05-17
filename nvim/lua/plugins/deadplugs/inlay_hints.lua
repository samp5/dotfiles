return {
  'lvimuser/lsp-inlayhints.nvim',
  config = function()
    require("lsp-inlayhints").setup({ inlay_hints = { highlight = "Comment" } })
  end
}
