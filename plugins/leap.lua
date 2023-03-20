return function()
  require("leap").setup {}

  local noremap = require("bombadil.lib.keymap").noremap
  local noremaps = require("bombadil.lib.keymap").noremaps

  ---@diagnostic disable-next-line: missing-parameter
  noremaps({ "n", "x" }, {
    s = { "<Plug>(leap-forward)", { desc = "Leap forward" } },
    S = { "<Plug>(leap-backward)", { desc = "Leap backward" } },
  })
  ---@diagnostic disable-next-line: missing-parameter
  noremaps("o", {
    x = { "<Plug>(leap-forward-x)", { desc = "Leap forward" } },
    X = { "<Plug>(leap-backward-x)", { desc = "Leap backward" } },
    z = { "<Plug>(leap-forward)", { desc = "Leap forward" } },
    Z = { "<Plug>(leap-backward)", { desc = "Leap backward" } },
  })
  noremap({ "n", "x", "o" }, "gs", "<Plug>(leap-cross-window)", { desc = "Character (cross-window)" })
end
