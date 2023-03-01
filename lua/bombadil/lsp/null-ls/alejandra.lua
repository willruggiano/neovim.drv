local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

local FORMATTING = methods.internal.FORMATTING

local sources = {}

sources.formatting = h.make_builtin {
  name = "alejandra",
  meta = {
    url = "https://github.com/kamadorueda/alejandra",
    description = "The Uncompromising Nix Code Formatter",
  },
  method = FORMATTING,
  filetypes = { "nix" },
  generator_opts = {
    command = "alejandra",
    to_stdin = true,
  },
  factory = h.formatter_factory,
}

return sources
