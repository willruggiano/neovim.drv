vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2
vim.opt_local.textwidth = 100

local nnoremap = require("bombadil.lib.keymap").nnoremap
local vnoremap = require("bombadil.lib.keymap").vnoremap

nnoremap("<leader><leader>rl", "<Plug>(Luadev-RunLine)", { buffer = bufnr, desc = "Exec line" })
nnoremap("<leader><leader>ro", "<Plug>(Luadev-Run)", { buffer = bufnr, desc = "Exec file" })
nnoremap("<leader><leader>rw", "<Plug>(Luadev-RunWord)", { buffer = bufnr, desc = "Exec word" })
vnoremap("<leader><leader>r", "<Plug>(Luadev-Run)", { buffer = bufnr, desc = "Exec selection" })
