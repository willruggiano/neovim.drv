local config = {
  settings = {
    ["nil"] = {
      formatting = {
        command = { "alejandra", "-qq" },
      },
    },
  },
} --[[@type vim.lsp.Config]]

return config
