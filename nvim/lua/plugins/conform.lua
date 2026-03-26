return {
  "conform.nvim",
  opts = {
    formatters_by_ft = {
      gdscript = { "gdscript_formatter" },
      kdl = { "kdlfmt", args = "--config ~/dotfiles/kdlfmt.kdl" },
    },
    formatters = {
      gdscript_formatter = {
        command = "/home/sam/42proj/tools/gdscript-formatter/linux-x86_64/gdscript-formatter-0.18.2-linux-x86_64",
        args = { "--use-spaces", "--indent-size=2", "--reorder-code", "--safe" },
      },
    },
  },
}
