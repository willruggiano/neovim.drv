local function pinspect(object)
  vim.pretty_print(object)
  return object
end

local reload = require("plenary.reload").reload_module

local function rreload(modname)
  reload(modname)
  return require(modname)
end

return {
  -- modules
  buffer = require "bombadil.lib.buffers",
  functional = require "bombadil.lib.functional",
  jump = require "bombadil.lib.jump",
  term = require "bombadil.lib.terminal",
  -- "global" functions
  pinspect = pinspect,
  reload = reload,
  rreload = rreload,
}
