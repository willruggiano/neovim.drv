return function()
  local inoremap = require("bombadil.lib.keymap").inoremap

  local tabout = require "tabout"

  -- NOTE: Disabling completion and manually setting it up below
  tabout.setup { completion = false }

  inoremap("<Tab>", tabout.tabout)
  inoremap("<S-Tab>", tabout.taboutBack)
end
