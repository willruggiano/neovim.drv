return function()
  require("leap").setup {}

  local noremap = require("bombadil.lib.keymap").noremap
  local noremaps = require("bombadil.lib.keymap").noremaps

  noremaps({ "n", "x" }, {
    s = { "<Plug>(leap-forward)", { desc = "Leap forward" } },
    S = { "<Plug>(leap-backward)", { desc = "Leap backward" } },
  })
  noremaps("o", {
    x = { "<Plug>(leap-forward-x)", { desc = "Leap forward" } },
    X = { "<Plug>(leap-backward-x)", { desc = "Leap backward" } },
    z = { "<Plug>(leap-forward)", { desc = "Leap forward" } },
    Z = { "<Plug>(leap-backward)", { desc = "Leap backward" } },
  })
  noremap({ "n", "x", "o" }, "gs", "<Plug>(leap-cross-window)", { desc = "Leap (cross-window)" })
  noremap({ "n", "x", "o" }, "ga", function()
    require("leap-ast").leap()
  end, { desc = "Leap (ast)" })
end
