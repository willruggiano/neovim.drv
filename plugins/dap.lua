return function()
  local dap = require "dap"
  local utils = require "dap.utils"

  dap.set_log_level "TRACE"

  dap.configurations.cpp = {
    {
      name = "Attach",
      type = "lldb",
      request = "attach",
      pid = utils.pick_process,
      args = {},
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
        return tonumber(vim.fn.input "Port: ")
      end,
    },
  }

  -- TODO: CodeLens to debug/run specific tests.
  -- This is more in the lsp.lua realm of things, but will want to be able to debug
  -- a specific test as well.
  -- I'm thinking two things:
  -- 1. CodeLens for all/each test in a test suite.
  -- 2. "Run current test", meaning under the cursor, which will require identifying which test is
  --    "current"
  dap.configurations.typescript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest test",
      runtimeExecutable = "node",
      runtimeArgs = function()
        local args = {
          "./node_modules/.bin/jest",
          "--runInBand",
          "--runTestsByPath",
        }

        local file = vim.api.nvim_buf_get_name(0)
        local configs = vim.fs.find(function(name, _)
          return name:match "jest%.config%.[%a]+$"
        end, {
          upward = true,
          stop = vim.fn.getcwd(),
          path = vim.fs.dirname(file),
        })

        if #configs == 0 then
          error "No jest config file found"
        end

        local config = configs[1]
        if #configs > 1 then
          error "More than one jest config file found"
        end

        return vim.list_extend(args, { "--config", config, file })
      end,
      rootPath = "${workspaceFolder}",
    },
  }

  dap.adapters.lldb = {
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
    controls = {
      element = "repl",
      enabled = false,
    },
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.25,
          },
          {
            id = "breakpoints",
            size = 0.25,
          },
          {
            id = "stacks",
            size = 0.25,
          },
          {
            id = "watches",
            size = 0.25,
          },
        },
        position = "left",
        size = 40,
      },
      {
        elements = {
          {
            id = "console",
            size = 1,
          },
        },
        position = "bottom",
        size = 10,
      },
    },
  }

  vim.api.nvim_create_user_command("DapToggleUI", function()
    dapui.toggle()
  end, { desc = "[dap] Toggle UI" })

  local nnoremaps = require("bombadil.lib.keymap").nnoremaps
  nnoremaps {
    -- ["]b"] = {
    --   function()
    --     --
    --   end,
    --   { desc = "[dap] Next breakpoint" }
    -- },
    -- ["[b"] = {
    --   function()
    --     --
    --   end,
    --   { desc = "[dap] Previous breakpoint" }
    -- },
    ["<F5>"] = {
      dap.continue,
      { desc = "[dap] Continue" },
    },
    ["<F8>"] = {
      dap.run_to_cursor,
      { desc = "[dap] Run to cursor" },
    },
    ["<F9>"] = {
      dap.toggle_breakpoint,
      { desc = "[dap] Toggle breakpoint" },
    },
    ["<F10>"] = {
      dap.step_over,
      { desc = "[dap] Step over" },
    },
    ["<F11>"] = {
      dap.step_into,
      { desc = "[dap] Step into" },
    },
    ["<F12>"] = {
      dap.step_out,
      { desc = "[dap] Step out" },
    },
    -- TODO: It'd be nice for this to be part of hover?
    ["<leader>e"] = {
      dapui.eval,
      { desc = "[dap] Evaluate expression" },
    },
  }

  vim.api.nvim_create_user_command("DapBreakpoints", function()
    dap.list_breakpoints(true)
  end, { desc = "[dap] Breakpoints (quickfix)" })
end
