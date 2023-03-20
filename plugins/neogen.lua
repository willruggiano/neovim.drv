return function()
  vim.api.nvim_create_user_command("Neogen", function()
    require("neogen").generate()
  end, { desc = "Neogen" })
end
