return function()
  local signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  }

  ---@diagnostic disable-next-line: undefined-field
  require("gitsigns").setup {
    signs = signs,
    signs_staged = signs,
    numhl = false,
    on_attach = function(bufnr)
      if vim.tbl_contains({ "netrw" }, vim.bo[bufnr].filetype) then
        return false
      end
    end,
  }
end
