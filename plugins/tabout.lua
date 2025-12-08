return function()
  local tabout = require "tabout"

  -- NOTE: Disabling completion and manually setting it up below
  ---@diagnostic disable-next-line: undefined-field
  tabout.setup { completion = false }

  vim.keymap.set("i", "<Tab>", tabout.tabout, { desc = "tabout.tabout()", noremap = true })
  vim.keymap.set("i", "<S-Tab>", tabout.taboutBack, { desc = "tabout.taboutback()", noremap = true })
end
