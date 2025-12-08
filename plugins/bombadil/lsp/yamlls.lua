local config = {
  file_types = { "yaml" },
  settings = {
    yaml = {
      schemas = require("schemastore").yaml.schemas(),
      validate = { enable = true },
    },
  },
} --[[@type vim.lsp.Config]]

return config
