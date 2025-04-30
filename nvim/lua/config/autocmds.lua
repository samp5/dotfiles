local api = vim.api

-- Highlight text on yank
api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "NeogitDiffAdd" })
  end,
})

-- Enable spell check on text and markdown files
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  {
    pattern = { "*.txt", "*.md" },
    callback = function()
      vim.opt.spell = true
    end
  }
)

-- Map escape to normal mode on all terminal
api.nvim_create_autocmd(
  { "TermOpen" },
  {
    callback = function(event)
      local wk = require 'which-key'
      wk.add({
        { "<Esc>", "<C-\\><C-n>", mode = { "t" }, buffer = { event.buf } }
      })
    end
  }
)

-- Be able to close the following with 'q'
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
