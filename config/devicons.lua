return function(plugin)
  vim.g.override_nvim_web_devicons = true
  local icons = require "nvim-nonicons"
  vim.opt.fillchars:append { foldclose = icons.get "chevron-right" }
end
