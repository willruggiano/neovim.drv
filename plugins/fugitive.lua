return function()
  local nnoremap = require("bombadil.lib.keymap").nnoremap
  nnoremap("<space>c", function()
    return "<cmd>Git difftool @ -- " .. vim.fn.expand "%" .. "<cr>"
  end, { desc = "Buffer changes", expr = true })
end
