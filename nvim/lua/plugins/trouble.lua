return {
  "folke/trouble.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("trouble").setup {}
    vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>",
      { silent = true, noremap = true }
    )
  end
}
