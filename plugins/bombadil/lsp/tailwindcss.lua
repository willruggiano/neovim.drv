local config = {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "css", "javascriptreact", "typescriptreact" },
  workspace_required = true,
  before_init = function(_, cfg)
    if not cfg.settings then
      cfg.settings = {}
    end
    if not cfg.settings.editor then
      cfg.settings.editor = {}
    end
    if not cfg.settings.editor.tabSize then
      cfg.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
  root_dir = function(bufnr, on_dir)
    local project_root_markers = { "tailwind.config.js", "tailwind.config.ts" }
    local project_root = vim.fs.root(bufnr, project_root_markers)
    on_dir(project_root)
  end,
  --
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      },
      includeLanguages = {},
    },
  },
} --[[@type vim.lsp.Config]]

return config
