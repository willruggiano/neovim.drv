return function()
  vim.opt.background = (function()
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
