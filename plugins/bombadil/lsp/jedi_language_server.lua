---@brief
---
--- https://github.com/pappasam/jedi-language-server
---
--- `jedi-language-server`, a language server for Python, built on top of jedi

---@type vim.lsp.Config
return {
  cmd = { "jedi-language-server" },
  filetypes = { "python" },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { "pyproject.toml" }))
  end,
}
