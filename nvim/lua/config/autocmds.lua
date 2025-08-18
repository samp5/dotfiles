local api = vim.api
local on_attach = require"lspbindings".on_attach

-- Highlight text on yank
api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "Visual" })
  end,
})

-- Enable spell check for:
-- 1. Markdown
-- 2. Text 
-- 3. Typst 
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  {
    pattern = { "*.txt", "*.md", "*.typ" },
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

api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = on_attach
})
