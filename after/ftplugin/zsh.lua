local shellexec = require "bombadil.lib.shellexec"

local nnoremap = require("bombadil.lib.keymap").buf_nnoremap

nnoremap("E.", shellexec.line, { desc = "Execute line" })
nnoremap("Ef", shellexec.file, { desc = "Execute file" })
