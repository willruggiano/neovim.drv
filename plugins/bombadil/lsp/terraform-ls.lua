local config = {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".git", ".terraform" },
} --[[@type vim.lsp.Config]]

return config
