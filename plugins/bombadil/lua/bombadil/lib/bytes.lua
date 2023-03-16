local M = {}

local bit = require "bit"
local byte = 1
local kb = bit.lshift(byte, 10)
local mb = bit.lshift(kb, 10)
local gb = bit.lshift(mb, 10)

local function format(size, divider, unit)
  local s = size / divider
  local i, f = math.modf(s)
  if f > 0 then
    return string.format("%.2f%s", s, unit)
  else
    return string.format("%d%s", i, unit)
  end
end

---Returns sizes like 1k, 234M, 2G etc.
---@param bytes number
M.human_readable = function(bytes)
  local divider = byte
  local unit = "" -- N.B. No unit for bytes, just like ls -lh
  if bytes >= gb then
    divider = gb
    unit = "G"
  elseif bytes >= mb then
    divider = mb
    unit = "M"
  elseif bytes >= kb then
    divider = kb
    unit = "k"
  end
  return format(bytes, divider, unit)
end

return M
