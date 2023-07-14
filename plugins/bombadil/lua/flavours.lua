local M = {}

local function hi(higroup, val)
  vim.api.nvim_set_hl(0, higroup, val)
end

local function link(higroup, link_to)
  hi(higroup, { link = link_to })
end

function M.setup()
  vim.opt.termguicolors = true

  local palette = M.palette()

  for key, value in pairs(palette) do
    hi(key .. "_fg", { fg = value, nocombine = true })
    hi(key .. "_bg", { bg = value, nocombine = true })
  end

  for _, what in ipairs { "vim", "syntax", "diagnostics", "lsp" } do
    require("flavours." .. what).setup(palette)
  end
end

function M.palette()
  local mode = vim.opt.background:get() or "dark"
  return require("flavours.palette")[mode]
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
