return function()
  local conform = require "conform"

  ---@param bufnr integer
  ---@param ... string
  ---@return string
  local function first(bufnr, ...)
    for i = 1, select("#", ...) do
      local formatter = select(i, ...)
      if conform.get_formatter_info(formatter, bufnr).available then
        return formatter
      end
    end
    return select(1, ...)
  end

  conform.setup {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
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
      bash = { "shellcheck", "shellharden", "shfmt" },
      graphql = { "prettier" },
      http = { "kulala" },
      javascript = function(bufnr)
        return { first(bufnr, "biome", "prettier"), "injected" }
      end,
      javascriptreact = function(bufnr)
        return { first(bufnr, "biome", "prettier"), "injected" }
      end,
      json = { "biome", "prettier", stop_after_first = true },
      lua = { "stylua" },
      markdown = { "prettier", "injected" },
      sh = { "shellcheck", "shellharden", "shfmt" },
      -- sql = { "sqlfmt" },
      typescript = function(bufnr)
        return { first(bufnr, "biome", "prettier"), "injected" }
      end,
      typescriptreact = function(bufnr)
        return { first(bufnr, "biome", "prettier"), "injected" }
      end,
      yaml = { "prettier" },
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
