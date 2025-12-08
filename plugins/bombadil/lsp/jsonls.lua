local config = {
  cmd = { "vscode-json-languageserver", "--stdio" },
  filetypes = { "json" },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
} --[[@type vim.lsp.Config]]

return config
