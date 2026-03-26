-- paths to check for project.godot file
local paths_to_check = {'/', '/../'}
local is_godot_project = false
local godot_project_path = ''
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for key, value in pairs(paths_to_check) do
    if vim.uv.fs_stat(cwd .. value .. 'project.godot') then
        is_godot_project = true
        godot_project_path = cwd .. value
        break
    end
end

-- check if server is already running in godot project path
local is_server_running = vim.uv.fs_stat(godot_project_path .. '/server.pipe')
-- start server, if not already running
if is_godot_project and not is_server_running then
    vim.fn.serverstart(godot_project_path .. '/server.pipe')
end

local port = os.getenv 'GDScript_Port' or '6005'
local cmd = vim.lsp.rpc.connect('127.0.0.1', tonumber(port))

local config = {
  cmd = cmd,
  filetypes = { 'gd', 'gdscript', 'gdscript3' },
  root_markers = { 'project.godot', '.git' },
}


vim.lsp.config('gdscript', config)
vim.lsp.enable('gdscript')


-- Dap config
local dap = require 'dap'

-- Default configuration
local dap_config = {
  dap = {
    host = "127.0.0.1",
    port = 6006, -- Default debug port
  },
}
dap.adapters.godot = {
  type = "server",
  host = dap_config.dap.host,
  port = dap_config.dap.port,
}

dap.configurations.gdscript = {
  {
    type = "godot",
    request = "launch",
    name = "Launch scene",
    launch_scene = true,
    project = "${workspaceFolder}",
  },
}

return {}
