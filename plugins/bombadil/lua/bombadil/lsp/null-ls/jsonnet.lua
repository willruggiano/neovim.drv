local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

local FORMATTING = methods.internal.FORMATTING

local sources = {}

sources.formatting = h.make_builtin {
  name = "jsonnetfmt",
  meta = {
    url = "https://github.com/google/jsonnet",
    description = "Jsonnet - The data templating language",
  },
  method = FORMATTING,
  filetypes = { "jsonnet" },
  generator_opts = {
    command = "jsonnetfmt",
    args = { "-" },
    to_stdin = true,
  },
  factory = h.formatter_factory,
}

return sources
