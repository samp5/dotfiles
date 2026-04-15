local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local M = {}

local function run_cppman(term)
  if vim.env.TMUX == nil then
    vim.notify(("TMUX env not detected. Aborting tmux split"):format(term), vim.log.levels.ERROR)
    return
  end

  local result = vim.system({ "cppman", "-f", term }, { text = true }):wait()

  if result.stdout and result.stdout:sub(1, 6):find("error") then
    vim.notify(("%s not found in cppman pages"):format(term), vim.log.levels.ERROR)
    return
  end

  vim.fn.system({ "tmux", "split-window", "-h", "cppman", term })
end

local function normalize_cpp_type(ty)
  ty = ty:gsub("%s*%b()", "") -- remove (aka ...)
  ty = ty:gsub("[%*&]", "")
  ty = ty:gsub("^const%s+", "")
  ty = ty:gsub("<.*>", "")
  return vim.trim(ty)
end

local function get_type_under_cursor(callback)
  local params = vim.lsp.util.make_position_params(0, "utf-16")

  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result)
    if err or not result or not result.contents then
      return
    end

    local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    local text = table.concat(lines, "\n")

    local ty = text:match("Type:%s*`([^`]+)`")
    callback(ty)
  end)
end

M.cppman_type_under_cursor = function()
  get_type_under_cursor(function(ty)
    if not ty then
      vim.notify("Error parsing type")
      return
    end
    run_cppman(normalize_cpp_type(ty))
  end)
end

M.cppman_picker = function(opts)
  opts = opts or {}

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 80 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.fqn, "TelescopeResultsFunction" },
      entry.keyword,
    })
  end

  pickers
    .new(opts, {
      prompt_title = "cppman",

      finder = finders.new_async_job({
        debounce = 100,
        command_generator = function(prompt)
          if not prompt or prompt == "" then
            return nil
          end
          return { "cppman", "-f", prompt }
        end,

        entry_maker = function(line)
          local search_term, fqn = line:match("^(.-)%s+%-%s+(.*)$")
          return {
            value = search_term,
            display = make_display,
            ordinal = search_term,
            keyword = search_term,
            fqn = fqn,
          }
        end,
      }),

      sorter = conf.generic_sorter(opts),

      -- previewer = previewers.new_termopen_previewer({
      --   get_command = function(entry)
      --     if not entry or not entry.word then
      --       return { "echo", "" }
      --     end
      --
      --     return { "cppman", entry.keyword }
      --   end,
      -- }),
      previewer = nil,

      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          run_cppman(selection.value)
        end)
        return true
      end,
    })
    :find()
end

return M
