return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    lazy = false,
    config = function()
      local open_with_trouble = require("trouble.sources.telescope").open
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local action_generate = require("telescope.actions.generate")

      -- Freeze the current grep results and re-sort them on filename only, so further
      -- typing narrows by path instead of by matched line text. Pressing the key again
      -- swaps back to the live grep with its original query restored and editable.
      local function toggle_filename_filter(prompt_bufnr)
        local picker = action_state.get_current_picker(prompt_bufnr)
        local saved = picker.__filename_filter

        if saved then
          picker.__filename_filter = nil
          picker.sorter:_destroy()
          picker.sorter = saved.sorter
          picker.sorter:_init()
          if picker.layout.prompt.border then
            picker.layout.prompt.border:change_title(saved.prompt_title)
          end
          -- Swap the finder back under an empty prompt (live grep runs no job until it
          -- has a query), then restore the query so only one rg run happens.
          picker:refresh(saved.finder, { reset_prompt = true })
          picker:set_prompt(saved.query)
          return
        end

        local found = false
        for entry in picker.manager:iter() do
          if entry.filename then
            -- Entries are metatable-backed, so a plain assignment shadows the lazy ordinal.
            -- Shorten the path so fuzzy matching isn't diluted by the cwd/home prefix.
            entry.ordinal = vim.fn.fnamemodify(entry.filename, ":~:.")
            found = true
          end
        end

        if not found then
          vim.notify("No file results to filter", vim.log.levels.WARN)
          return
        end

        local query = action_state.get_current_line()
        -- Stashed on the picker so it dies with the picker instead of leaking.
        picker.__filename_filter = {
          finder = picker.finder,
          sorter = picker.sorter,
          prompt_title = picker.prompt_title,
          query = query,
        }

        action_generate.refine(prompt_bufnr, {
          prompt_title = string.format("Filter Filename (%s)", query),
        })
      end

      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "*/build/*", "*.class", "*.o", "*.a" },
          path_display = { "smart" },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--multiline",
          },
          layout_strategy = "flex",
          selection_caret = " ",
          prompt_prefix = " ",
          multi_icon = " ",
          mappings = {
            i = {
              ["<C-t>"] = open_with_trouble,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
            },
            n = { ["<C-t>"] = open_with_trouble },
          },
        },
        pickers = {
          live_grep = {
            mappings = {
              i = { ["<M-f>"] = toggle_filename_filter },
              n = { ["<M-f>"] = toggle_filename_filter },
            },
          },
          grep_string = {
            mappings = {
              i = { ["<M-f>"] = toggle_filename_filter },
              n = { ["<M-f>"] = toggle_filename_filter },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      local tele = require("telescope.builtin")
      local wk = require("which-key")
      local ic = require("mini.icons")
      local theme = require("telescope.themes")

      -- Directory of the current buffer, falling back to cwd for scratch/unnamed buffers.
      local function buf_dir()
        local dir = vim.fn.expand("%:p:h")
        if dir == "" or vim.fn.isdirectory(dir) == 0 then
          dir = vim.uv.cwd()
        end
        return dir
      end

      -- Live grep scoped to `dir`, with <M-u>/<M-d> to walk up/back down the directory
      -- structure without losing the current query.
      local function live_grep_dir(dir, default_text, stack)
        stack = stack or {}
        tele.live_grep({
          search_dirs = { dir },
          default_text = default_text,
          prompt_title = "Live Grep: " .. vim.fn.fnamemodify(dir, ":~:."),
          attach_mappings = function(prompt_bufnr, map)
            local function jump(to, next_stack)
              local query = action_state.get_current_line()
              actions.close(prompt_bufnr)
              vim.schedule(function()
                live_grep_dir(to, query, next_stack)
              end)
            end

            map({ "i", "n" }, "<M-u>", function()
              local parent = vim.fn.fnamemodify(dir, ":h")
              if parent == dir then
                return
              end
              jump(parent, vim.list_extend({ dir }, stack))
            end)

            map({ "i", "n" }, "<M-d>", function()
              if #stack == 0 then
                return
              end
              local child = stack[1]
              jump(child, vim.list_slice(stack, 2))
            end)

            return true
          end,
        })
      end

      wk.add({
        {
          "<leader>f",
          group = "[F]ind",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fc",
          tele.current_buffer_fuzzy_find,
          desc = "FF Current Buffer",
          icon = { icon = "󰮗", color = "blue" },
        },
        {
          "<leader>fd",
          tele.diagnostics,
          desc = "Diagnostics",
          icon = { icon = "", color = "red" },
        },
        {
          "<leader>ff",
          function()
            tele.find_files(theme.get_dropdown({
              previewer = false,
            }))
          end,
          desc = "Find files",
          icon = { icon = "󰈞", color = "blue" },
        },
        {
          "<leader>fF",
          group = "[F]iles (special)",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fh",
          tele.help_tags,
          desc = "Help tags",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fl",
          tele.colorscheme,
          desc = "Colorscheme",
          icon = { icon = ic.get("lsp", "color"), color = "yellow" },
        },
        {
          "<leader>fm",
          function()
            tele.man_pages({ sections = { "1", "2", "3", "7" } })
          end,
          desc = "Man pages",
          icon = { icon = ic.get("filetype", "help"), color = "blue" },
        },
        {
          "<leader>fr",
          tele.resume,
          desc = "Resume search",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fs",
          tele.live_grep,
          desc = "Live Grep (<M-f> toggles filename filter)",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fS",
          group = "[S]earch (special)",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fSl",
          function()
            live_grep_dir(buf_dir())
          end,
          desc = "Live Grep (local dir, <M-u>/<M-d> dirs, <M-f> filename)",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fw",
          tele.lsp_workspace_symbols,
          desc = "Workspace Symbols",
          icon = { icon = ic.get("lsp", "class"), color = "blue" },
        },
        {
          "<leader>fb",
          tele.buffers,
          desc = "Buffers",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fj",
          function()
            tele.jumplist(theme.get_dropdown({
              previewer = true,
            }))
          end,
          desc = "Jumplist",
          icon = { icon = "", color = "blue" },
        },

        { "<leader>fg", group = "[G]it", icon = { icon = "", color = "blue" } },
        {
          "<leader>fgb",
          tele.git_bcommits,
          desc = "Buffer commits",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fgc",
          tele.git_commits,
          desc = "Commits",
          icon = { icon = "", color = "blue" },
        },
        {
          "<leader>fgs",
          tele.git_stash,
          desc = "Stash",
          icon = { icon = "", color = "yellow" },
        },
        {
          "<leader>fgo",
          function()
            local git_icons = {
              added = "",
              changed = "󰜥",
              copied = "",
              deleted = "",
              renamed = "󱀱",
              unmerged = "‡",
              untracked = "",
            }
            tele.git_status({
              git_icons = git_icons,
            })
          end,
          desc = "Status",
          icon = { icon = "󱖫", color = "green" },
        },
      })
    end,
  },
}
