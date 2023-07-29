return function()
  ---@diagnostic disable-next-line: missing-fields
  require("overseer").setup {
    component_aliases = {
      default = {
        { "display_duration", detail_level = 2 },
        "on_output_summarize",
        "on_exit_set_status",
        "on_complete_notify",
      },
      default_vscode = {
        "default",
        { "on_result_diagnostics_quickfix", open = true },
      },
    },
  }

  vim.api.nvim_create_user_command("Run", function(opts)
    local args = vim.fn.expandcmd(opts.args)
    local task = require("overseer").new_task {
      cmd = args,
      components = {
        "default",
        { "on_output_quickfix", open = opts.bang },
      },
    }
    task:start()
  end, { bang = true, desc = "Run an external command", nargs = "*" })

  local nnoremaps = require("bombadil.lib.keymap").nnoremaps

  nnoremaps {
    ["<space>r"] = {
      "<cmd>OverseerRun<cr>",
      { desc = "Run" },
    },
    ["<space>t"] = {
      function()
        require("overseer.commands")._toggle { bang = true, args = "bottom" }
      end,
      { desc = "Tasks" },
    },
  }
end
