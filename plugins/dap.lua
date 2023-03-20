return function()
  local dap = require "dap"
  local json = require "rapidjson"
  local utils = require "dap.utils"

  dap.set_log_level "TRACE"

  dap.configurations.lua = {
    {
      type = "nlua",
      request = "attach",
      name = "Attach to running Neovim instance",
      host = function()
        return "127.0.0.1"
      end,
      port = function()
        local val = tonumber(vim.fn.input "Port: ")
        assert(val, "Please provide a port number")
        return val
      end,
    },
  }

  dap.configurations.cpp = {
    {
      name = "Attach",
      type = "cppdbg",
      request = "attach",
      pid = utils.pick_process,
      args = {},
    },
    {
      name = "Launch",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    },
  }

  dap.adapters.cppdbg = {
    type = "executable",
    command = "lldb-vscode",
    name = "lldb",
  }

  dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host, port = config.port }
  end

  local loaded_launch_json = {}
  local launch_json = ".vscode/launch.json"

  vim.api.nvim_create_user_command("Debug", function()
    if vim.fn.filereadable(launch_json) == 1 and loaded_launch_json[launch_json] == nil then
      local config = json.load(launch_json)
      for _, c in ipairs(config.configurations) do
        if c.type == "cppdbg" then
          table.insert(dap.configurations.cpp, c)
        end
      end
      loaded_launch_json[launch_json] = true
    end
    dap.continue()
  end, { desc = "Start debugger" })

  vim.api.nvim_create_user_command("DebugConfig", function()
    if vim.fn.exists(launch_json) then
      vim.cmd(string.format("edit %s", launch_json))
    end
  end, { desc = "Edit debuffer config" })

  vim.g.dap_virtual_text = true

  local dapui = require "dapui"
  dapui.setup {
    sidebar = {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 00.25 },
      },
      size = 50,
      position = "left",
    },
    tray = {
      elements = { "repl" },
      size = 15,
      position = "bottom",
    },
    floating = {
      max_height = nil,
      max_width = nil,
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
  }

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end
