return function()
  local undotree = require "undotree"
  undotree.setup()
  vim.api.nvim_create_user_command("Undo", function()
    undotree.toggle()
  end, { desc = "Undotree" })
end
