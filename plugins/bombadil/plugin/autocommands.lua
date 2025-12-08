local group = vim.api.nvim_create_augroup("bombadil", { clear = true })
local hi = require "bombadil.lib.highlight"

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function()
    vim.fn.mkdir(vim.fn.expand "%:p:h", "p")
  end,
})

vim.api.nvim_create_autocmd("BufWrite", {
  group = group,
  callback = function()
    vim.snippet.stop()
    vim.cmd.nohlsearch()
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    hi.CursorLine = {}
    hi.CursorLineNr = { fg = hi.Cursor.bg }
    hi.MsgArea = "Pmenu"
    hi.NormalFloat = "Pmenu"
    hi.PreInsert = "Comment"
    hi.StatusLine = "Pmenu"
    hi.TabLineFill = "Pmenu"
    hi.WinSeparator = { fg = hi.Pmenu.bg }
  end,
})
