vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2
vim.opt_local.textwidth = 100

local buf_noremap = require("bombadil.lib.keymap").buf_noremap

buf_noremap("n", "<leader><leader>rl", "<Plug>(Luadev-RunLine)", { desc = "Exec line" })
buf_noremap("n", "<leader><leader>ro", "<Plug>(Luadev-Run)", { desc = "Exec file" })
buf_noremap("n", "<leader><leader>rw", "<Plug>(Luadev-RunWord)", { desc = "Exec word" })
buf_noremap("v", "<leader><leader>r", "<Plug>(Luadev-Run)", { desc = "Exec selection" })
