--[[@type vim.lsp.Config]]
local config = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { "go.mod" }))
  end,
  init_options = {
    semanticTokens = true,
  },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      gofumpt = true,
      staticcheck = true,
    },
  },
}

return config
