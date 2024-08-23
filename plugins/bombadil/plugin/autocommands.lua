local group = vim.api.nvim_create_augroup("bombadil", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function()
    ---@diagnostic disable-next-line: missing-parameter
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
