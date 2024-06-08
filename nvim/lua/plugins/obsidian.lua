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
    local colors = require "kanagawa.colors".setup()
    local p = colors.palette
    require('obsidian').setup({
      workspaces = {
        {
          name = "school",
          path = "~/obsidian/school",
        },
        --   {
        --     name = "no-vault",
        --     path = function()
        --       -- alternatively use the CWD:
        --       -- return assert(vim.fn.getcwd())
        --       return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        --     end,
        --     overrides = {
        --       notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
        --       new_notes_location = "current_dir",
        --       templates = {
        --         folder = vim.NIL,
        --       },
        --       disable_frontmatter = true,
        --     },
        --   },
      },

      completion = {
        nvim_cmp = true,
      },

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>rc"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
        ["<leader>rr"] = {
          action = function()
            local x = require "trouble"
            x.toggle({ mode = "lsp_ref" })
          end,
          opt = { buffer = true, expr = true }
        }
      },

      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "xdg-open", url })
      end,

      ui = {
        hl_groups = {
          ObsidianTodo = { bold = true, fg = p.springViolet1 },
          ObsidianDone = { bold = true, fg = p.waveAqua2 },
          ObsidianRightArrow = { bold = true, fg = p.springBlue },
          ObsidianTilde = { bold = true, fg = p.samuariRed },
          ObsidianBullet = { bold = true, fg = p.springViolet1 },
          ObsidianRefText = { underline = true, fg = p.waveAqua2 },
          ObsidianExtLinkIcon = { fg = p.crystalBlue },
          ObsidianTag = { italic = true, fg = p.boatYellow2 },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
          ObsidianHeading1 = { bold = true, fg = p.boatYellow2 },
          ObsidianHeading2 = { bold = true, fg = p.carpYellow },
          ObsidianHeading3 = { bold = true, fg = p.boatYellow1 },
          ObsidianHeading4 = { bold = true, fg = p.dragonBlue },
          ObsidianHeading5 = { bold = true, fg = p.waveAqua1 },
          ObsidianHeading6 = { bold = true, fg = p.springBlue },
        },
      },
      templates = {
        folder = "z_templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          class = function()
            local user_input
            vim.ui.input({ prompt = "Class: " },
              function(input)
                user_input = input
              end)
            return user_input
          end
        }
      }
    })
    vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { link = "ObsidianHeading1" })
    vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { link = "ObsidianHeading2" })
    vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { link = "ObsidianHeading3" })
    vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { link = "ObsidianHeading4" })
    vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { link = "ObsidianHeading5" })
    vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { link = "ObsidianHeading6" })
  end
}
