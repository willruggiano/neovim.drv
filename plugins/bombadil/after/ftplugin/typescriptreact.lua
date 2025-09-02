vim.cmd.compiler "tsc"
vim.opt_local.formatoptions:remove "o"
vim.treesitter.start(0, "tsx")
