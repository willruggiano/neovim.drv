local M = {}

local noremap = function(...)
  vim.keymap.set(..., { buffer = 0, noremap = true })
end

M.register_buffer = function(group)
  group = group or "default"

  noremap("n", "<C-a>", require("dial.map").inc_normal(group))
  noremap("n", "<C-x>", require("dial.map").dec_normal(group), { buffer = 0 })
  noremap("v", "<C-a>", require("dial.map").inc_visual(group), { buffer = 0 })
  noremap("v", "<C-x>", require("dial.map").dec_visual(group), { buffer = 0 })
  noremap("v", "g<C-a>", require("dial.map").inc_gvisual(group), { buffer = 0 })
  noremap("v", "g<C-x>", require("dial.map").dec_gvisual(group), { buffer = 0 })
end

return M
