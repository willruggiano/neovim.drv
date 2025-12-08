vim.cmd.packadd "cfilter"

vim.g.netrw_liststyle = 3 -- tree
vim.g.netrw_list_hide = vim.fn["netrw_gitignore#Hide"]()
vim.cmd.packadd "netrw"
