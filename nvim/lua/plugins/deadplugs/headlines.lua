return {
  "lukas-reineke/headlines.nvim",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    vim.cmd [[highlight CodeBlock guibg=#303030]]
    vim.cmd [[highlight Headline1 guibg=#1e2718]]
    vim.cmd [[highlight Headline2 guibg=#21262d]]
    vim.cmd [[highlight markdownCode guibg=#303030]]
    require('headlines').setup {
      markdown = {
        headline_highlights = { "Headline1", "Headline2" },
      }
    }
  end, -- or `opts = {}`
}


