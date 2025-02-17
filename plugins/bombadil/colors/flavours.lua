-- REMOVEME: once I get darkman.nvim to work :/
local bg = os.capture "darkman get"

if bg then
  vim.opt.background = bg
end

require("flavours").setup(bg)

vim.g.colors_name = "flavours"
