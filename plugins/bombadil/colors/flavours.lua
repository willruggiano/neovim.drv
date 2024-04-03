vim.opt.background = (function()
  if vim.env.BG ~= nil then
    assert(vim.env.BG == "dark" or vim.env.BG == "light", "BG != dark|light")
    return vim.env.BG
  end
  local t = os.date "*t"
  if t.hour < 8 or t.hour >= 17 then
    return "dark"
  else
    return "light"
  end
end)()

require("flavours").setup()

vim.g.colors_name = "flavours"
