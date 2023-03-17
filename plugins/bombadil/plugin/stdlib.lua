---Captures the output of a program.
---@param cmd string the command to run
---@param raw boolean if true, command output will be returned as is, else beginning/trailing spaces
--and newlines will be removed
---@return string
---@see io.popen
os.capture = function(cmd, raw)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read "*a")
  f:close()
  if raw then
    return s
  end
  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", " ")
  return s
end

---Checks if a string contains the given substring.
---@param sub string
---@return boolean
function string:contains(sub)
  return self:find(sub, 1, true) ~= nil
end

---Checks if a string starts with the given string.
---@param start string
---@return boolean
function string:startswith(start)
  return self:sub(1, #start) == start
end

---Checks if a string ends with the given string.
---@param ending string
---@return boolean
function string:endswith(ending)
  return ending == "" or self:sub(-#ending) == ending
end

---Replaces all instances of substring with a new substring.
---@param old string the substring to be replaced
---@param new string the substring to replace with
---@return string
function string:replace(old, new)
  local s = self
  local search_start_idx = 1

  while true do
    local start_idx, end_idx = s:find(old, search_start_idx, true)
    if not start_idx then
      break
    end
    local postfix = s:sub(end_idx + 1)
    s = s:sub(1, start_idx - 1) .. new .. postfix
    search_start_idx = -1 * postfix:len()
  end

  return s
end

---Inserts a string at a specific position.
---@param pos number
---@param text string
---@return string
function string:insert(pos, text)
  return self:sub(1, pos - 1) .. text .. self:sub(pos)
end

---@diagnostic disable-next-line: lowercase-global
utf8 = require "lua-utf8"
