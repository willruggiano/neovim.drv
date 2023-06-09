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

  for _, lang in ipairs { "javascript", "typescript" } do
    dap.configurations[lang] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = utils.pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Jest Tests",
        runtimeExecutable = "node",
        runtimeArgs = {
          "./node_modules/jest/bin/jest.js",
          "--runInBand",
        },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
    }
  end

  dap.adapters.cppdbg = {
    type = "executable",
    command = "lldb-vscode",
    name = "lldb",
  }

  dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host, port = config.port }
  end

  require("dap.ext.vscode").load_launchjs(nil, {
    ["pwa-node"] = { "javascript", "typescript" },
  })

  vim.api.nvim_create_user_command("Debug", function()
    dap.continue()
  end, { desc = "Start debugger" })

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
