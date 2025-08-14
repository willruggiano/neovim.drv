local config = {
  capabilities = {
    workspace = {
      didChangeConfiguration = { dynamicRegistration = true },
    },
  },
  cmd = { "postgrestools", "lsp-proxy" },
  filetypes = { "sql" },
  single_file_support = true,
  settings = {
    db = {
      host = vim.env.PGHOST,
      database = vim.env.PGDATABASE,
      username = vim.env.PGUSER,
      password = vim.env.PGPASSWORD,
    },
  },
} --[[@type vim.lsp.Config]]

return config
