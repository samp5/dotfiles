return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = false },
    notifier = {
      enabled = true,
      style = "minimal",
      top_down = false,
      margin = { bottom = 2 },
    },
    styles = {
      notification = {
        wo = { winblend = 100 }
      }
    },
  },
}
