local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new {
  cmd = "lazygit",
  direction = "float",
  float_opts = { border = "none" },
  close_on_exit = true,
  hidden = true,
}

vim.keymap.set("n", "<space>g", function()
  lazygit:toggle()
end, { desc = "lazygit:toggle()", noremap = true })

vim.keymap.set("n", "gb", function()
  vim.cmd("!git blame -L " .. vim.fn.line "." .. ",+1 -- %")
end, { desc = ":!git blame cursor line" })
