return function()
  require("notify").setup {
    render = "compact",
    stages = "static",
  }

  vim.notify = require "notify"
end
