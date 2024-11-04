return function()
  local js = { "biome", "injected" }
  local sh = { "shfmt", "shellcheck", "shellharden" }

  local conform = require "conform"

  conform.setup {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      biome = {
        command = "biome", -- not necessarily from node_modules/.bin
      },
      -- ["biome-check"] = {
      --   command = "biome", -- ditto.
      -- },
      kulala = {
        command = "kulala-fmt",
        args = { "$FILENAME" },
        stdin = false,
      },
      stylua = {
        require_cwd = true, -- only when it finds the root marker
      },
    },
    formatters_by_ft = {
      bash = sh,
      graphql = { "prettier" },
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

  conform.formatters.injected = {
    options = {
      ignore_errors = false,
      lang_to_formatters = {
        sql = { "sqlfluff" }, -- what are the odds this works?
      },
    },
  }

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format {
        bufnr = args.buf,
        lsp_fallback = true,
        quiet = true,
      }
    end,
  })
end
