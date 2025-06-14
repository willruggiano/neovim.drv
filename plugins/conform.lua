return function()
  local conform = require "conform"

  ---@source https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#run-the-first-available-formatter-followed-by-more-formatters
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
      biome = {
        command = "biome",
      },
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
      graphql = { "prettier" },
      http = { "kulala" },
      javascript = function(bufnr)
        return { first(bufnr, "biome", "prettier"), "injected" }
      end,
      javascriptreact = function(bufnr)
        return { first(bufnr, "biome", "prettier"), "injected" }
      end,
      json = { "jq" },
      lua = { "stylua" },
      markdown = { "prettier", "injected" },
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
