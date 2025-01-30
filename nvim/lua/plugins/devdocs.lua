return {
  "samp5/nvim-devdocs",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require 'nvim-devdocs'.setup({
      dir_path = vim.fn.stdpath("data") .. "/devdocs", -- installation directory
      telescope = {},                                  -- passed to the telescope picker
      wrap = true,                                     -- text wrap, only applies to floating window
      picker_cmd_args = {},                            -- example using glow: { "-s", "dark", "-w", "50" }
      mappings = {
      },
      ensure_installed = {}, -- get automatically installed
      after_open = function(bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', {})
      end, -- callback that runs after the Devdocs window is opened. Devdocs buffer ID will be passed in
    })
  end
}
