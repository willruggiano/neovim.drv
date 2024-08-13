return function()
  local signs = require "bombadil.lsp.signs"

  require("quicker").setup {
    borders = {
      vert = "|",
      strong_header = "-",
      strong_cross = "+",
      strong_end = "|",
      soft_header = "-",
      soft_cross = "+",
      soft_end = "|",
    },
    keys = {
      {
        ">",
        function()
          require("quicker").expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
    opts = {
      number = true,
      relativenumber = true,
      signcolumn = "yes",
    },
    type_icons = {
      E = signs.severity(vim.diagnostic.severity.ERROR),
      W = signs.severity(vim.diagnostic.severity.WARN),
      I = signs.severity(vim.diagnostic.severity.INFO),
      N = signs.severity(vim.diagnostic.severity.INFO),
      H = signs.severity(vim.diagnostic.severity.HINT),
    },
  }
end
