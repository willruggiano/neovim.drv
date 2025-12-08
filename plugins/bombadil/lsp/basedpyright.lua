---@brief
---
--- https://detachhead.github.io/basedpyright
---
--- `basedpyright`, a static type checker and language server for python

---@type vim.lsp.Config
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { "pyproject.toml" }))
  end,
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}
