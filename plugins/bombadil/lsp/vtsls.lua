---@type vim.lsp.Config
local config = {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = { "tsconfig.json", "package.json", ".git" },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
  },
}

return config
