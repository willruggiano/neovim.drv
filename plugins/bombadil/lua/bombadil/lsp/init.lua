local M = {}

M.jump_to_location = function(location)
  local uri = location.uri or location.targetUri
  if uri == nil then
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)

  if vim.api.nvim_buf_is_loaded(bufnr) then
    local wins = vim.fn.win_findbuf(bufnr)
    if wins then
      vim.fn.win_gotoid(wins[1])
    end
  end

  if vim.lsp.util.jump_to_location(location, "utf-8", true) then
    vim.cmd "normal! zz"
  end
end

M.kind = {
  init = require("lspkind").init,
}

M.peek_definition = require "bombadil.lsp.peek"

M.signs = require "bombadil.lsp.signs"

return M
