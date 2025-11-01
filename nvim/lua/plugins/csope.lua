return {
  "dhananjaylatkar/cscope_maps.nvim",
  ft = { "c", "h", "S"},
  dependencies = {
    "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
  },
  opts = {},
  config = function()
    require("cscope_maps").setup(
      {
        cscope = {
          picker = "telescope",
        }
      })
  end
}
