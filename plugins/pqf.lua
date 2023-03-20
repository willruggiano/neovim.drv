return function()
  ---@diagnostic disable-next-line: missing-parameter
  local signs = require("bombadil.lsp.signs").get()

  require("pqf").setup {
    signs = {
      error = signs.Error,
      hint = signs.Hint,
      info = signs.Info,
      warning = signs.Warn,
    },
  }
end
