local config = {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { "pyproject.toml" }))
  end,
  settings = {
    ty = {
      experimental = {
        autoImport = true,
        rename = true,
      },
    },
  },
} --[[@type vim.lsp.Config]]

return config
