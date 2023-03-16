require("treesitter-unit").disable_highlighting()

local zk = require "zk"

require("bombadil.lib.keymap").buf_noremaps("n", {
  ["<leader>zb"] = {
    function()
      zk.edit({ linkTo = { vim.api.nvim_buf_get_name(0) } }, { title = "Backlinks" })
    end,
    { desc = "Backlinks" },
  },
  ["<leader>zl"] = {
    function()
      zk.edit({ linkedBy = { vim.api.nvim_buf_get_name(0) } }, { title = "Links" })
    end,
    { desc = "Links" },
  },
})
