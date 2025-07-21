local function hi(higroup, val)
  vim.api.nvim_set_hl(0, higroup, vim.tbl_extend("keep", val, { force = true }))
end

local function link(higroup, link_to)
  hi(higroup, { link = link_to, force = true })
end

local M = setmetatable({}, {
  __newindex = function(_, higroup, args)
    if type(args) == "string" then
      link(higroup, args)
      return
    end

    hi(higroup, args)
  end,
})

return M
