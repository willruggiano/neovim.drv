local util = require "lspconfig.util"

return {
  default_config = {
    cmd = { "sqruff", "lsp" },
    filetypes = { "sql" },
    single_file_support = true,
  },
}
