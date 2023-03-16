local M = {}

M.file = function()
  local filename = vim.fn.expand "%"
  vim.cmd("!" .. filename)
end

M.line = function()
  local shell = vim.o.shell
  local linenr = vim.fn.line "."
  local line = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  vim.cmd(string.format("!%s -c %s", shell, line))
end

return M
