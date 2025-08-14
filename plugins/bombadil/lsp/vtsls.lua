local config = {
  root_markers = { "tsconfig.json" },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
  },
} --[[@type vim.lsp.Config]]

return config
