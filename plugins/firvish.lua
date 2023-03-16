return function()
  require("buffers-firvish").setup {}
  -- require("git-firvish").setup {}
  require("firvish-history").setup()
  require("jobs-firvish").setup {}

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<space>b", function()
    vim.cmd.edit "firvish://buffers"
    require("buffers-firvish").setup_buffer(vim.api.nvim_get_current_buf(), false)
  end, { desc = "Buffers" })

  nnoremap("<space>h", function()
    vim.cmd.edit "firvish://history"
  end, { desc = "History" })

  nnoremap("<space>j", function()
    vim.cmd.pedit "firvish://jobs"
  end, { desc = "Jobs" })
end
