require("bombadil.lib.keymap").nnoremap("?", function()
  require("nvim-cheat"):new_cheat(false)
end, { desc = "Cheatsheet" })
