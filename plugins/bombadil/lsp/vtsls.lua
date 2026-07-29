---@type vim.lsp.Config
local config = {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = function(bufnr, on_dir)
    local project_root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lock" }
    local project_root = vim.fs.root(bufnr, project_root_markers)
    on_dir(project_root) -- nil == single file/no workspace
  end,
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
    },
  },
}

return config
