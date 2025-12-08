return function()
  local dap = require "dap"
  local utils = require "dap.utils"

  ---@diagnostic disable-next-line: undefined-field
  dap.adapters.lldb = {
    type = "executable",
    command = "lldb-vscode",
    name = "lldb",
  }

  ---@diagnostic disable-next-line: undefined-field
  dap.configurations.cpp = {
    {
      name = "Attach",
      type = "lldb",
      request = "attach",
      pid = utils.pick_process,
      args = {},
    },
  }

  ---@diagnostic disable-next-line: undefined-field
  dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host, port = config.port }
  end

  ---@diagnostic disable-next-line: undefined-field
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

  local mappings = {
    ["gdd"] = {
      ---@diagnostic disable-next-line: undefined-field
      dap.continue,
      { desc = "dap.continue()" },
    },
    ["gd."] = {
      ---@diagnostic disable-next-line: undefined-field
      dap.run_to_cursor,
      { desc = "dap.run_to_cursor()" },
    },
    ["gdb"] = {
      ---@diagnostic disable-next-line: undefined-field
      dap.toggle_breakpoint,
      { desc = "dap.toggle_breakpoint()" },
    },
    ["gd]"] = {
      ---@diagnostic disable-next-line: undefined-field
      dap.step_over,
      { desc = "dap.step_over()" },
    },
    ["gd>"] = {
      ---@diagnostic disable-next-line: undefined-field
      dap.step_into,
      { desc = "dap.step_into()" },
    },
    ["gd<"] = {
      ---@diagnostic disable-next-line: undefined-field
      dap.step_out,
      { desc = "dap.step_out()" },
    },
    ["gdl"] = {
      ---@diagnostic disable-next-line: undefined-field
      function()
        ---@diagnostic disable-next-line: undefined-field
        dap.list_breakpoints(true)
      end,
      { desc = "dap.list_breakpoints()" },
    },
  }

  for lhs, map in pairs(mappings) do
    vim.keymap.set("n", lhs, map[1], vim.tbl_extend("keep", map[2], { noremap = true }))
  end
end
