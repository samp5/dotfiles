return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    keywords = {
      TEST = { icon = "󰙨", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      QST = { icon = "", color = "info" },
    }
  },

}
