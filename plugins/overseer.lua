return function()
  require("overseer").setup()

  vim.api.nvim_create_user_command("Run", function(opts)
    local args = vim.fn.expandcmd(opts.args)
    local task = require("overseer").new_task {
      cmd = args,
      components = {
        { "on_output_quickfix", open = opts.bang },
        "default",
      },
    }
    task:start()
  end, { bang = true, desc = "Run an external command", nargs = "*" })

  local nnoremaps = require("bombadil.lib.keymap").nnoremaps

  nnoremaps {
    ["<space>t"] = {
      function()
        require("overseer.commands")._toggle { bang = true, args = "bottom" }
      end,
      { desc = "Tasks" },
    },
  }
end
