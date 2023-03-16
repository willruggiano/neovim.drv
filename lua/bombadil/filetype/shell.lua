return function(bufnr)
  local shellexec = require "bombadil.lib.shellexec"

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("E.", shellexec.line, { buffer = bufnr, desc = "Execute line" })
  nnoremap("Ef", shellexec.file, { buffer = bufnr, desc = "Execute file" })
end
