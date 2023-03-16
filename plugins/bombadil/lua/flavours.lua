local M = {}

function M.setup()
  vim.opt.termguicolors = true

  local palette = require "flavours.palette"
  for _, what in ipairs { "vim", "syntax", "diagnostics", "lsp" } do
    require("flavours." .. what).setup(palette)
  end
end

local function hi(higroup, val)
  vim.api.nvim_set_hl(0, higroup, val)
end

local function link(higroup, link_to)
  hi(higroup, { link = link_to })
end

M.highlight = setmetatable({}, {
  __newindex = function(_, higroup, args)
    if type(args) == "string" then
      link(higroup, args)
      return
    end

    hi(higroup, args)
  end,
})

return M
