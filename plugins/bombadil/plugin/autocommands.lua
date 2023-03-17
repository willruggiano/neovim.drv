local group = vim.api.nvim_create_augroup("bombadil", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function()
    ---@diagnostic disable-next-line: missing-parameter
    vim.fn.mkdir(vim.fn.expand "%:p:h", "p")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = vim.highlight.on_yank,
})

vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter", "WinEnter" }, {
  group = group,
  pattern = "term://*",
  callback = function()
    vim.cmd "startinsert"
  end,
})
