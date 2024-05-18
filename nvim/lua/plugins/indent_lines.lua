return {
  "lukas-reineke/indent-blankline.nvim",
  config = function()
    require('ibl').setup({
      enabled = true,
      indent = {
        char = '┆'
      },
      scope = {
        char = '│',
        show_start = false,
      }
    })
  end
}
