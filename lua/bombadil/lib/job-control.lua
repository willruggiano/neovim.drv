local firvish = require "firvish"

local M = {}

---Run an executable.
---@param command string The command to run.
---@param args table? The arguments to pass to the command.
---@param errorlist string|boolean? One of (quickfix|loclist|false) specifying whether to send command output to an errorlist, or `false` to run the command in the foregroud.
M.run = function(command, args, errorlist)
  local background = errorlist ~= nil or errorlist ~= false

  firvish.start_job {
    command = command,
    args = args or {},
    filetype = "log",
    title = command,
    errorlist = errorlist,
    eopen = background,
    bopen = false,
  }
end

return M
