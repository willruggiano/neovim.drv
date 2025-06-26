local Terminal = require("toggleterm.terminal").Terminal
local claude = Terminal:new {
  cmd = "claude",
  direction = "float",
  float_opts = { border = "single" },
  close_on_exit = false, -- to see session stats
  hidden = true,
}

local nnoremap = require("bombadil.lib.keymap").nnoremap
nnoremap("<space>c", function()
  ---@diagnostic disable-next-line: missing-parameter
  claude:toggle()
end, { desc = "Claude" })
