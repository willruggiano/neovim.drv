return function()
  require("marks").setup {}

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<leader>mb", function()
    vim.api.nvim_command "MarksListBuf"
  end, { desc = "Buffer marks" })

  nnoremap("<leader>ml", function()
    vim.api.nvim_command "MarksListAll"
  end, { desc = "Marks" })
end
