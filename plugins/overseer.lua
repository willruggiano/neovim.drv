return function()
  local o = require "overseer"

  ---@diagnostic disable-next-line: missing-fields
  o.setup {
    component_aliases = {
      default = {
        { "display_duration", detail_level = 2 },
        -- "on_output_summarize",
        "on_exit_set_status",
        "on_complete_notify",
      },
      default_vscode = {
        "default",
        { "on_result_diagnostics_quickfix", open = true },
      },
    },
  }

  o.register_template {
    name = "Run File (ts-node)",
    builder = function()
      local file = vim.fn.expand "%"
      return {
        cmd = { "ts-node" },
        args = { "-T", file },
        strategy = {
          "toggleterm",
          open_on_start = true,
          direction = "horizontal",
          on_create = function()
            vim.cmd.stopinsert()
          end,
        },
      }
    end,
    condition = {
      filetype = { "typescript" },
    },
  }

  local nnoremaps = require("bombadil.lib.keymap").nnoremaps

  nnoremaps {
    ["<space><cr>"] = {
      "<cmd>OverseerRunCmd<cr>",
      { desc = "RunCmd" },
    },
    ["<space>r"] = {
      "<cmd>OverseerRun<cr>",
      { desc = "Run" },
    },
    ["<space>t"] = {
      "<cmd>OverseerToggle bottom<cr>",
      { desc = "Tasks" },
    },
  }
end
