return function()
  require("nvim-nonicons").setup()
  vim.opt.fillchars:append { foldclose = require("nvim-nonicons").get "chevron-right" }
end
