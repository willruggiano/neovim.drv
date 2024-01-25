return function()
  local js = { { "biome", "prettier" } }
  local sh = { "shfmt", "shellcheck", "shellharden" }

  require("conform").setup {
    formatters_by_ft = {
      bash = sh,
      javascript = js,
      javascriptreact = js,
      lua = { "stylua", "luacheck" },
      markdown = { "prettier", "injected" },
      sh = sh,
      sql = { "sqlfluff" },
      typescript = js,
      typescriptreact = js,
      yaml = { "prettier" },
    },
    formatters = {
      biome = {
        command = "biome", -- not necessarily from node_modules/.bin
      },
      sqlfluff = {
        prepend_args = { "--dialect", "postgres" },
      },
      stylua = {
        require_cwd = true, -- only when it finds the root marker
      },
    },
  }

  vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
end
