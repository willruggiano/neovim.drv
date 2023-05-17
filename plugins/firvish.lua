return function()
  require("firvish").setup()
  require("buffers-firvish").setup()

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  -- nnoremap("<space>b", function()
  --   require("firvish").extensions.buffers_t:run()
  -- end, { desc = "Buffers" })

  nnoremap("<space>j", function()
    require("firvish").extensions.jobs()
  end, { desc = "Jobs" })
end
