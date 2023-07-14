return function()
  vim.opt.background = (function()
    local t = os.date "*t"
    -- Use light theme between 8am and 8pm, light theme otherwise
    return t.hour < 8 or t.hour > 20 and "dark" or "light"
  end)()
  vim.cmd.colorscheme "flavours"
end
