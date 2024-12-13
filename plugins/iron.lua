return function()
  local iron = require "iron.core"
  local view = require "iron.view"

  iron.setup {
    config = {
      highlight_last = false,
      repl_definition = {
        sql = {
          command = { "psql" },
        },
        typescript = {
          command = { "bun", "repl" },
        },
      },
      repl_open_cmd = view.split "30%",
    },
  }

  vim.keymap.set("x", "<C-M>", function()
    iron.send(nil, iron.mark_visual())
  end, { desc = "[repl] visual send" })
end
