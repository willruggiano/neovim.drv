return function()
  local toggleterm = require "toggleterm"

  toggleterm.setup {
    shade_terminals = false,
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<space><space>", function()
    toggleterm.toggle_command("size=20", vim.api.nvim_get_current_win())
  end, { desc = "Toggle terminal" })
end
