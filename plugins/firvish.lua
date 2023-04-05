return function()
  require("firvish").setup()
  require("buffers-firvish").setup()
  -- require("git-firvish").setup {}
  -- require("firvish-history").setup()
  require("jobs-firvish").setup()

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<space>b", function()
    require("firvish").extensions.buffers:open()
  end, { desc = "Buffers" })

  -- nnoremap("<space>h", function()
  --   vim.cmd.edit "firvish://history"
  -- end, { desc = "History" })

  nnoremap("<space>j", function()
    require("firvish").extensions.jobs:open()
  end, { desc = "Jobs" })
end
