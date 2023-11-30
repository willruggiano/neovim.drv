return function()
  vim.opt.background = (function()
    if vim.env.BG ~= nil then
      return vim.env.BG
    end
    local t = os.date "*t"
    if t.hour < 8 or t.hour > 17 then
      return "dark"
    else
      return "light"
    end
  end)()
  vim.cmd.colorscheme "flavours"
end
