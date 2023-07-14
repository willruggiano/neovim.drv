local hi = require("flavours").highlight

local M = {}

function M.setup(palette)
  -- See: |group-name|
  hi.Comment = { fg = palette.base04, italic = true }
  hi.Constant = { fg = palette.base09 }
  hi.String = { fg = palette.base0B }
  -- hi.Character = "Constant"
  -- hi.Number = "Constant"
  -- hi.Boolean = "Constant"
  -- hi.Float = "Constant"

  hi.Identifier = { fg = palette.base08 }
  hi.Function = { fg = palette.base0D }

  hi.Statement = { fg = palette.base0E, italic = true }
  -- hi.Conditional = "Statement"
  -- hi.Repeat = "Statement"
  -- hi.Label = "Statement"
  hi.Operator = { fg = palette.base0E }
  -- hi.Keyword = "Statement"
  -- hi.Exception = "Statement"

  hi.PreProc = { fg = palette.base0A }
  -- hi.Include = "PreProc"
  -- hi.Define = "PreProc"
  -- hi.Macro = "PreProc"
  -- hi.Precondit = "PreProc"

  hi.Type = { fg = palette.base0A }
  -- hi.StorageClass = "Type"
  -- hi.Structure = "Type"
  -- hi.Typedef = "Type"

  hi.Special = { fg = palette.base0C }
  -- hi.SpecialComment = "Special"
  -- hi.SpecialChar = "Special"
  -- hi.Tag = "Special"
  -- hi.Delimiter = "Special"
  -- hi.Debug = "Special"

  hi.Underlined = { underline = true }

  hi.Ignore = {}

  hi.Error = { fg = palette.base08 }

  hi.Todo = { fg = palette.base0A }
end

return M
