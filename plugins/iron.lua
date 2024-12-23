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

  vim.keymap.set("n", "<C-w>x", function()
    iron.send_file()
  end, { desc = "[iron] send file" })

  vim.keymap.set("x", "<C-M>", function()
    iron.visual_send()
  end, { desc = "[iron] visual send" })
end
