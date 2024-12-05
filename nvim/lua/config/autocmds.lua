local api = vim.api

api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "NeogitDiffAdd" })
  end,
})

api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  {
    pattern = { "*.txt", "*.md" },
    callback = function()
      vim.opt.spell = true
    end
  }
)

api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "man",
    "checkhealth",
    "qf",
    "lspinfo",
  },
  callback = function(event)
    local wk = require 'which-key'
    vim.bo[event.buf].buflisted = false
    wk.add({
      { "q", "<cmd>close<CR>", buffer = event.buf }
    })
  end,
}
)
api.nvim_create_autocmd({ 'BufRead' }, {
  callback = function() vim.o.foldlevel = 99 end
})
