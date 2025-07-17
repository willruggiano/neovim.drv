-- neovim builtin comments don't support block
-- vim.opt_local.comments = "s:/*,mb:*,ex:*/,:#" -- // nix be simple
vim.opt_local.formatoptions:remove "o"
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.treesitter.start()
