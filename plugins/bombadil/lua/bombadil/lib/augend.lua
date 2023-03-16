local nnoremap = require("bombadil.lib.keymap").nnoremap
local vnoremap = require("bombadil.lib.keymap").vnoremap

local M = {}

M.register_buffer = function(group)
  group = group or "default"

  nnoremap("<C-a>", require("dial.map").inc_normal(group), { buffer = 0 })
  nnoremap("<C-x>", require("dial.map").dec_normal(group), { buffer = 0 })
  vnoremap("<C-a>", require("dial.map").inc_visual(group), { buffer = 0 })
  vnoremap("<C-x>", require("dial.map").dec_visual(group), { buffer = 0 })
  vnoremap("g<C-a>", require("dial.map").inc_gvisual(group), { buffer = 0 })
  vnoremap("g<C-x>", require("dial.map").dec_gvisual(group), { buffer = 0 })
end

return M
