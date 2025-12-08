---@brief
---
--- https://github.com/elm-tooling/elm-language-server#installation
---
--- If you don't want to use Nvim to install it, then you can use:
--- ```sh
--- npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { "elm-language-server" },
  -- TODO(ashkan) if we comment this out, it will allow elmls to operate on elm.json. It seems like it could do that, but no other editor allows it right now.
  filetypes = { "elm" },
  root_markers = { "elm.json" },
  init_options = {
    elmReviewDiagnostics = "off", -- 'off' | 'warning' | 'error'
    skipInstallPackageConfirmation = false,
    disableElmLSDiagnostics = false,
    onlyUpdateDiagnosticsOnSave = false,
  },
  capabilities = {
    offsetEncoding = { "utf-8", "utf-16" },
  },
}
