local ok, terminal = pcall(require, "toggleterm.terminal")
if not ok then
  return
end

local close_term_if_open = function()
  local ui = require "toggleterm.ui"
  local terminals = terminal.get_all()
  if not ui.find_open_windows() then
    return -- No open terminal
  end
  local target
  for i = #terminals, 1, -1 do
    local term = terminals[i]
    if term and ui.term_has_open_win(term) then
      target = term
      break
    end
  end
  if not target then
    return -- No open terminal
  end
  target:close()
end

local Terminal = terminal.Terminal

local function run_command(interactive, prog, ...)
  local cmd = { prog }
  local args = { ... }
  if #args > 0 then
    for _, a in ipairs(args) do
      cmd[#cmd + 1] = a
    end
  end
  local term = Terminal:new {
    cmd = table.concat(cmd, " "),
    direction = "horizontal",
    border = "single",
    hidden = true,
    close_on_exit = true,
  }
  if interactive then
    term:open()
  end
end

return {
  close = close_term_if_open,
  run_command = run_command,
}
