return function()
  require("triptych").setup()
  vim.keymap.set("n", "-", "<cmd>Triptych<cr>", { silent = true, desc = "Triptych" })
end
