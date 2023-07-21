local h = require "null-ls.helpers"
local methods = require "null-ls.methods"
local FORMATTING = methods.internal.FORMATTING

local sources = {}

sources.formatting = h.make_builtin {
  name = "prismaFmt",
  meta = {
    url = "https://github.com/prisma/prisma-engines",
    description = "Formatter for the prisma filetype.",
  },
  method = FORMATTING,
  filetypes = { "prisma" },
  generator_opts = {
    command = "prisma-fmt",
    args = { "format" },
    to_stdin = true,
  },
  factory = h.formatter_factory,
}

return sources
