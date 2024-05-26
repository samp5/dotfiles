return {
  'willothy/nvim-cokeline',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    'nvim-lua/plenary.nvim',
  },

  config = function()
    local popup = require("plenary.popup")

    local function create_window(tab)
    end

    require('cokeline').setup({
      components = {
        {
          text = function(buffer) return ' ' .. buffer.index .. ' ' end,
          bold = true,
        },
        {
          text = function(buffer)
            if buffer.pick_letter ~= string.sub(buffer.filename, 0, 1) then
              return ' (' .. buffer.pick_letter .. ') '
            else
              return ''
            end
          end,
          italic = true,
        },
        {
          text = function(buffer) return ' ' .. buffer.devicon.icon end,
          fg = function(buffer) return buffer.devicon.color end,
        },
        {
          text = function(buffer) return buffer.filename .. ' ' end,
        },
        {
          text = function(buffer) if buffer.diagnostics.errors > 0 then return '   ' else return '' end end,
          -- same red as return statements
          fg = '#f45a60'
        },
        {
          text = function(buffer) if buffer.is_modified then return '󰆓 ' else return '' end end,
        },
        {
          text = '󰅖',
          on_click = function(_, _, _, _, buffer)
            buffer:delete()
          end
        },
        {
          text = ' ',
        }
      },
      tabs = {
        placement = "right",
        components = {
          {
            text = function(tab)
              if tab.is_active then
                return ' ' .. tab.index .. ' '
              else
                return ' ' .. tab.index .. ' '
              end
            end,
            fg = function(tab) if tab.is_active then return "#DCD7BA" else return "#938AA9" end end,
            bg = function(tab) if tab.is_active then return "#2A2A37" else return "#16161D" end end,
            bold = true,
            on_click = function(_, _, _, _, tab)
              local files = {}
              local n = 0
              local windows = vim.api.nvim_tabpage_list_wins(tab.number)
              for i, w in ipairs(windows) do
                local buf = vim.api.nvim_win_get_buf(w)
                local path = vim.api.nvim_buf_get_name(buf)
                n = n + 1
                files[i] = path
              end

              local width       = 60
              local height      = 10
              local bufner      = vim.api.nvim_create_buf(false, true)
              local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

              local win_id, win = popup.create(bufner, {
                title = "Windows",
                line = math.floor(((vim.o.lines - height) / 2) - 1),
                col = math.floor((vim.o.columns - width) / 2),
                minwidth = width,
                minheight = height,
                borderchars = borderchars,
              })
              vim.api.nvim_buf_set_lines(bufner, 0, n, false, files)
              local command = ":lua vim.api.nvim_win_close(" .. win_id .. ",true)<CR>"
              vim.api.nvim_buf_set_keymap(bufner, "n", "q", command, { silent = true })
            end,
          },
        }
      }
    })

    vim.keymap.set('n', '<leader>tv', function()
      local files = {}
      local n = 0
      local tab = vim.api.nvim_get_current_tabpage()
      local windows = vim.api.nvim_tabpage_list_wins(tab)
      for i, w in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(w)
        local path = vim.api.nvim_buf_get_name(buf)
        n = n + 1
        files[i] = path
      end

      local width       = 60
      local height      = 10
      local bufner      = vim.api.nvim_create_buf(false, true)
      local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

      local win_id, win = popup.create(bufner, {
        title = "Windows",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
      })
      vim.api.nvim_buf_set_lines(bufner, 0, n, false, files)
      local command = ":lua vim.api.nvim_win_close(" .. win_id .. ",true)<CR>"
      vim.api.nvim_buf_set_keymap(bufner, "n", "q", command, { silent = true })
      local file_path = vim.api.nvim_get_current_line()
      local command2 = ":q | :e " .. file_path .. "<CR>"
      vim.api.nvim_buf_set_keymap(bufner, "n", "<CR>", command2, { silent = true })
    end)

    vim.keymap.set('n', 'H', '<Plug>(cokeline-focus-prev)', { noremap = true, desc = 'Focus previous buffer' })
    vim.keymap.set('n', 'L', '<Plug>(cokeline-focus-next)', { noremap = true, desc = 'Focus next buffer' })
    vim.keymap.set('n', 'X', '<Plug>(cokeline-pick-close)', { noremap = true, desc = 'Pick close' })
    vim.keymap.set("n", "<leader>p", function()
      require('cokeline.mappings').pick("focus")
    end, { desc = "Pick a buffer to focus" })
  end
}
