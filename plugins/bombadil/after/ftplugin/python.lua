-- `import foo`
--         ^^^ @lsp.type.namespace.python
vim.api.nvim_set_hl(0, "@lsp.type.namespace.python", { link = "Type", force = true })

vim.treesitter.start()
