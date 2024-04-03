return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter",
  },
  config = function()
    vim.wo.cole = 1
    require('obsidian').setup({
      workspaces = {
        {
          name = "school",
          path = "~/obsidian/SCHOOL",
        },
      },

      hl_groups = {
        ObsdianBlockID = { italic = true, bg = "90ddff" },
      },

      -- key maps
      vim.keymap.set("n", "<leader>ch", function()
        return "<cmd>lua require('obsidian').util.toggle_checkbox()"
      end, { buffer = true }),

      vim.keymap.set("n", "gl", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })
    })
  end
}
