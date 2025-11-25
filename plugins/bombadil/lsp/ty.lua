local config = {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml" },
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
