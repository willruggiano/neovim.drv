return function()
  require("triptych").setup {
    diagnostic_signs = {
      enabled = false,
    },
  }

  vim.keymap.set("n", "-", "<cmd>Triptych<cr>", { silent = true, desc = "Triptych" })
end
