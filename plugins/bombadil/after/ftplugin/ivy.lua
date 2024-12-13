vim.keymap.set("n", "<C-j>", function()
  vim.ivy.next()
end, { buffer = 0 })
--
vim.keymap.set("n", "<C-n>", function()
  vim.ivy.next()
  vim.ivy.checkpoint()
end, { buffer = 0 })

vim.keymap.set("n", "<C-k>", function()
  vim.ivy.previous()
end, { buffer = 0 })
--
vim.keymap.set("n", "<C-p>", function()
  vim.ivy.previous()
  vim.ivy.checkpoint()
end, { buffer = 0 })
