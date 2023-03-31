return function()
  local icons = require "nvim-nonicons"

  require("diffview").setup {
    icons = {
      folder_closed = icons.get "file-directory",
      folder_open = icons.get "file-directory",
    },
    signs = {
      fold_closed = icons.get "chevron-right",
      fold_open = icons.get "chevron-down",
      done = icons.get "check",
    },
  }
end
