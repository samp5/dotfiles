return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", },


  config = function()
    require "oil".setup({
      view_options = {
        show_hidden = true
      },
      float = {
        max_height = vim.api.nvim_win_get_width(0) ,
        max_width  = vim.api.nvim_win_get_height(0),
      },
    })
    local o = require "oil"
    local wk = require "which-key"

    wk.register({
      ['<leader>e'] = {
        name = "Fil[E] Exploxer",
        e = { o.open, "Open file explorer" },
        f = { o.toggle_float, "Float file explorer" },
      }
    })
  end
}
