return function()
  require("firvish").setup()
  require("buffers-firvish").setup()
  -- require("git-firvish").setup()
  -- require("firvish-history").setup()
  require("jobs-firvish").setup()

  local has_netrw, netrw = pcall(require, "netrw-firvish")
  if has_netrw then
    netrw.setup()
  end

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  -- if has_netrw then
  --   nnoremap("-", function()
  --     require("firvish").extensions.netrw()
  --   end, { desc = "Explore" })
  -- end

  nnoremap("<space>b", function()
    require("firvish").extensions.buffers()
  end, { desc = "Buffers" })

  -- nnoremap("<space>h", function()
  --   vim.cmd.edit "firvish://history"
  -- end, { desc = "History" })

  nnoremap("<space>j", function()
    require("firvish").extensions.jobs()
  end, { desc = "Jobs" })
end
