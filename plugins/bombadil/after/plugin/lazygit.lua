local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new {
  cmd = "lazygit",
  direction = "float",
  float_opts = { border = "none" },
  close_on_exit = true,
  hidden = true,
}

vim.keymap.set("n", "<space>g", function()
  ---@diagnostic disable-next-line: missing-parameter
  lazygit:toggle()
end, { desc = "Lazygit", noremap = true })
