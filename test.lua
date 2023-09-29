local nnoremap = require("bombadil.lib.keymap").nnoremap

nnoremap("<space>d", function()
  vim.api.nvim_cmd({
    cmd = "DBUIToggle",
    mods = {
      silent = true,
    },
  }, {})
end, { desc = "[dadbod] Toggle" })
