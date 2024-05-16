local Terminal = require("toggleterm.terminal").Terminal
local devenv = Terminal:new {
  cmd = "devenv up",
  direction = "float",
  float_opts = {
    border = "none",
  },
  hidden = true,
}

local nnoremap = require("bombadil.lib.keymap").nnoremap
nnoremap("<space>v", function()
  ---@diagnostic disable-next-line: missing-parameter
  devenv:toggle()
end, { desc = "Devenv" })
