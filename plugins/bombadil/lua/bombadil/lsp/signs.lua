local icons = require "nvim-nonicons"
local f = require "bombadil.lib.functional"

local signs = {
  Error = icons.get "circle-slash",
  Hint = icons.get "light-bulb",
  Info = icons.get "info",
  Warn = icons.get "alert",
}

local severity = vim.diagnostic.severity
local severity_to_sign = {
  [severity.ERROR] = "Error",
  [severity.HINT] = "Hint",
  [severity.INFO] = "Info",
  [severity.WARN] = "Warn",
}

local M = {}

---@param lower boolean
M.get = function(lower)
  if lower then
    local s = {}
    for k, v in pairs(signs) do
      s[string.lower(k)] = v
    end
    return s
  else
    return signs
  end
end

---@param func function
M.map = function(func)
  f.each(function(...)
    return func(signs, ...)
  end, ipairs(vim.tbl_keys(signs)))
end

M.severity = function(i)
  return signs[severity_to_sign[i]]
end

return M
