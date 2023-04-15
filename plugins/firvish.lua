return function()
  require("firvish").setup()
  require("buffers-firvish").setup()
  -- require("git-firvish").setup {}
  -- require("firvish-history").setup()
  require("jobs-firvish").setup()
  require("netrw-firvish").setup()

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("-", function()
    require("firvish").extensions.netrw {}
  end, { desc = "Explore" })

  nnoremap("<space>b", function()
    require("firvish").extensions.buffers {}
  end, { desc = "Buffers" })

  -- nnoremap("<space>h", function()
  --   vim.cmd.edit "firvish://history"
  -- end, { desc = "History" })

  nnoremap("<space>j", function()
    require("firvish").extensions.jobs {}
  end, { desc = "Jobs" })
end
