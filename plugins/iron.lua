return function()
  local iron = require "iron.core"
  local view = require "iron.view"

  iron.setup {
    config = {
      repl_definition = {
        typescript = {
          command = { "ts-node" },
        },
      },
      repl_open_cmd = view.split "30%",
    },
  }
end
