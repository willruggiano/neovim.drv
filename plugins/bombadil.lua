return function()
  vim.opt.background = (function()
    if vim.env.BG ~= nil then
      return vim.env.BG
    end
    local t = os.date "*t"
    -- Use light theme between 8am and 8pm, light theme otherwise
    if t.hour < 8 or t.hour > 20 then
      return "dark"
    else
      return "light"
    end
  end)()
  vim.cmd.colorscheme "flavours"
end
