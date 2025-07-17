vim.cmd.compiler "tsc"
-- neovim builtin comments don't support block
-- vim.opt_local.comments = "sO:* -,mO:*  ,exO:*/,s1:/*,mb:*,ex:*/,:///,://"
vim.opt_local.formatoptions:remove "o"
vim.treesitter.start()
