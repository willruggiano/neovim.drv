return function()
  local js = { "biome", "prettier", stop_after_first = true }
  local sh = { "shfmt", "shellcheck", "shellharden" }

  require("conform").setup {
    formatters = {
      biome = {
        command = "biome", -- not necessarily from node_modules/.bin
      },
      kulala = {
        command = "kulala-fmt",
        args = { "$FILENAME" },
        stdin = false,
      },
      sqlfluff = {
        args = { "fix", "--disable-progress-bar", "-" },
      },
      stylua = {
        require_cwd = true, -- only when it finds the root marker
      },
    },
    formatters_by_ft = {
      bash = sh,
      http = { "kulala" },
      javascript = js,
      javascriptreact = js,
      json = { "biome", "prettier", stop_after_first = true },
      lua = { "stylua", "luacheck" },
      markdown = { "prettier", "injected" },
      sh = sh,
      sql = { "sqlfluff" },
      typescript = js,
      typescriptreact = js,
      yaml = { "prettier" },
    },
  }

  vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
end
