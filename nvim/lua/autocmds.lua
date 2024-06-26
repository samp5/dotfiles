local autocommands = function()
  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    callback = function()
      vim.cmd("normal zz")
    end
  })

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank({ higroup = "NeogitDiffAdd" })
    end,
  })
end

return {
  autocommands = autocommands
}
