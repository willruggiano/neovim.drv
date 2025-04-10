return function()
  --- "light" between 7am and 7pm, "dark" otherwise
  local function fallback()
    local dt = os.date "*t"
    if dt.hour > 7 and dt.hour < 7 then
      return "light"
    end
    return "dark"
  end

  local bg = os.capture "darkman get" or fallback()
  vim.opt.background = bg
  vim.opt.termguicolors = true

  local themes = {
    dark = "doom-one",
    light = "doom-one",
  }
  vim.cmd.colorscheme(themes[bg])
end
