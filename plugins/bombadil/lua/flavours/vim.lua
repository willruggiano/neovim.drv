local hi = require("flavours").highlight

local M = {}

function M.setup(palette)
  -- See: |highlight-groups|
  hi.ColorColumn = { bg = palette.base01 }
  hi.Conceal = { fg = palette.base0D, bg = palette.base00 }
  hi.CurSearch = {}
  hi.Cursor = { fg = palette.base00, bg = palette.base05 }
  hi.CursorColumn = { bg = palette.base01 }
  hi.CursorLine = { bg = palette.base01 }
  hi.Directory = { fg = palette.base0D }
  hi.DiffAdd = { fg = palette.base0B }
  hi.DiffChange = { fg = palette.base0A }
  hi.DiffDelete = { fg = palette.base08 }
  hi.DiffText = { fg = palette.base0D }
  -- hi.EndOfBuffer = "NonText"
  hi.ErrorMsg = { fg = palette.base08, bg = palette.base00 }
  hi.WinSeparator = { fg = palette.base04, bg = palette.base00 }
  hi.Folded = { fg = palette.base03, bg = palette.base01 }
  hi.FoldColumn = { fg = palette.base0C, bg = palette.base00 }
  hi.SignColumn = { fg = palette.base04, bg = palette.base00 }
  hi.IncSearch = { fg = palette.base01, bg = palette.base09 }
  -- hi.Substitute = "IncSearch"
  hi.LineNr = { fg = palette.base04 }
  -- hi.LineNrAbove = "LineNr"
  -- hi.LineNrBelow = "LineNr"
  -- hi.CursorLineNr = "LineNr"
  -- hi.CursorLineFold = "FoldColumn"
  -- hi.CursorLineSign = "SignColumn"
  hi.MatchParen = { bg = palette.base03 }
  hi.ModeMsg = { fg = palette.base0B }
  hi.MoreMsg = { fg = palette.base0B }
  hi.NonText = { fg = palette.base03 }
  hi.Normal = { fg = palette.base05, bg = palette.base00 }
  hi.NormalFloat = "Normal"
  hi.PMenu = { fg = palette.base05, bg = palette.base01 }
  hi.PMenuSel = { fg = palette.base01, bg = palette.base05 }
  hi.Question = { fg = palette.base0D }
  hi.QuickFixLine = { bg = palette.base01 }
  hi.Search = { fg = palette.base01, bg = palette.base0A }
  hi.SpecialKey = { fg = palette.base03 }
  hi.SpellBad = { sp = palette.base08, undercurl = true }
  hi.SpellCap = { sp = palette.base0D, undercurl = true }
  hi.SpellLocal = { sp = palette.base0C, undercurl = true }
  hi.SpellRare = { sp = palette.base0E, undercurl = true }
  hi.StatusLine = { fg = palette.base05, bg = palette.base02 }
  hi.StatusLineNC = { fg = palette.base04, bg = palette.base01 }
  hi.TabLine = { fg = palette.base03, bg = palette.base01 }
  hi.TabLineFill = { fg = palette.base03, bg = palette.base01 }
  hi.TabLineSel = { fg = palette.base0B, bg = palette.base01 }
  hi.Title = { fg = palette.base0D }
  hi.Visual = { bg = palette.base02 }
  hi.VisualNOS = { fg = palette.base08 }
  hi.WarningMsg = { fg = palette.base08 }
  -- hi.Whitespace = "NonText"
  hi.WildMenu = { fg = palette.base08, bg = palette.base0A }
  hi.WinBar = { fg = palette.base05 }
  hi.WinBarNC = { fg = palette.base04 }
end

return M
