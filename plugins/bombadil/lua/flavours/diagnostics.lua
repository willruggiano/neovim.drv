local hi = require("flavours").highlight

local M = {}

function M.setup(palette)
  -- See: |diagnostic-highlights|
  hi.DiagnosticOk = { fg = palette.base0B }
  hi.DiagnosticError = { fg = palette.base08 }
  hi.DiagnosticWarn = { fg = palette.base0E }
  hi.DiagnosticInfo = { fg = palette.base05 }
  hi.DiagnosticHint = { fg = palette.base0C }

  -- hi.DiagnosticVirtualTextOk = "DiagnosticOk"
  -- hi.DiagnosticVirtualTextError = "DiagnosticError"
  -- hi.DiagnosticVirtualTextWarn = "DiagnosticWarn"
  -- hi.DiagnosticVirtualTextInfo = "DiagnosticInfo"
  -- hi.DiagnosticVirtualTextHint = "DiagnosticHint"

  hi.DiagnosticUnderlineOk = { undercurl = true }
  hi.DiagnosticUnderlineError = { undercurl = true }
  hi.DiagnosticUnderlineWarn = { undercurl = true }
  hi.DiagnosticUnderlineInfo = { undercurl = true }
  hi.DiagnosticUnderlineHint = { undercurl = true }
end

return M
