return function()
  local dap = require "dap"
  local utils = require "dap.utils"

  require("dap-vscode-js").setup {
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    debugger_path = vim.fn.expand "~/dev/vscode-js-debug",
  }

  dap.set_log_level "TRACE"

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

  dap.adapters.cppdbg = {
    type = "executable",
    command = "lldb-vscode",
    name = "lldb",
  }

  dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host, port = config.port }
  end

  if
    not pcall(function()
      require("dap.ext.vscode").load_launchjs(nil, {
        ["pwa-node"] = { "javascript", "typescript" },
      })
    end)
  then
    vim.notify("Failed to load .vscode/launch.json", vim.log.levels.DEBUG)
  end

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

  local nnoremaps = require("bombadil.lib.keymap").nnoremaps
  local prefix = "<space>d"
  nnoremaps {
    [prefix .. "bt"] = {
      dap.toggle_breakpoint,
      { desc = "[dap] Toggle breakpoint" },
    },
    [prefix .. "c"] = {
      dap.continue,
      { desc = "[dap] Continue" },
    },
    [prefix .. "e"] = {
      dapui.eval,
      { desc = "[dap] Evaluate expression" },
    },
    [prefix .. "so"] = {
      dap.step_over,
      { desc = "[dap] Step over" },
    },
    [prefix .. "si"] = {
      dap.step_into,
      { desc = "[dap] Step into" },
    },
  }
end
