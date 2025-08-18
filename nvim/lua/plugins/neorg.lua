local set_neorg_hl = function(name, attrs)
  for _, hl in ipairs(name) do
    vim.api.nvim_set_hl(0, "@neorg." .. hl, attrs);
  end
end

return {
  "nvim-neorg/neorg",
  dependencies = {"nvim-neorg/neorg-telescope"},
  lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = "*", -- Pin Neorg to the latest stable release
  config = function()
    require 'neorg'.setup {
      load = {
        ["core.defaults"] = {},
        ["core.export"] = {},
        ["core.qol.todo_items"] = {},
        ["core.integrations.telescope"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp"
          }
        },
        ["core.concealer"] = {
          config = {
            icons = {
              heading = {
                icons = { "=", "==", "===", "====", "=====", "======" },
              },
              todo = {
                done = {
                  icon = "x"
                },
                pending = {
                  icon = "?"
                },
                urgent = {
                  icon = "!"
                }
              }
            },
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
          },
        },
      }
    }

    -- neorg keymaps
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("neorg", { clear = false }),
      pattern = {
        "norg"
      },
      callback = function(event)
        local wk = require 'which-key'

        local norg_todo = function(action)
          return "<Plug>(neorg.qol.todo-items.todo." .. action .. ")"
        end
        local norg_tele = function(action)
          return "<Plug>(neorg.telescope." .. action .. ")"
        end

        wk.add({
          -- todo keys
          { "<leader>t", group = "[T]o-dos", buffer = { event.buf }, icon = { icon = " ", color = "green" } },
          { "<leader>td", norg_todo("task-done"), buffer = event.buf, desc = "[D]one" },
          { "<leader>tu", norg_todo("task-undone"), buffer = event.buf, desc = "[U]ndone" },
          { "<leader>tp", norg_todo("task-pending"), buffer = event.buf, desc = "[P]ending" },
          { "<leader>th", norg_todo("task-on_hold"), buffer = event.buf, desc = "On-[H]old" },
          { "<leader>ti", norg_todo("task-important"), buffer = event.buf, desc = "[I]mportant" },

          { "<leader>fn", group = "[N]eorg", buffer = event.buf},
          { "<leader>fnb", norg_tele("file_backlinks"), buffer = event.buf, desc = "[B]acklinks" },
          { "<leader>fnl", norg_tele("find_linkable"), buffer = event.buf, desc = "[L]inkable" },
          { "<leader>fni", norg_tele("insert_link"), buffer = event.buf, desc = "[L]inkable" },
        })
      end,
    }
    )

    -- set highlights
    local wc = require 'kanagawa.colors'.setup({ theme = "wave" }).palette;

    -- heading colors
    local heading_colors = { wc.dragonBlue, wc.crystalBlue, wc.springBlue, wc.waveAqua2, wc.springGreen, wc.boatYellow1 }
    for i = 1, 6, 1 do
      set_neorg_hl({ "headings." .. i .. ".prefix" }, { fg = heading_colors[i], bold = true })
      set_neorg_hl({ "headings." .. i .. ".title" }, { fg = heading_colors[i], bold = true })
    end

    -- code blocks
    set_neorg_hl({ "tags.ranged_verbatim.code_block" }, { bg = wc.sumiInk4 })

    -- todos
    set_neorg_hl({ "todo_items.urgent" }, { fg = wc.samuraiRed, bg = "bg", bold = true })
  end


}
