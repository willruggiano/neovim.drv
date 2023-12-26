local hi = require("flavours").highlight

local M = {}

function M.setup(palette)
  local d = {
    ok = palette.base0B,
    error = palette.base08,
    warn = palette.base0E,
    info = palette.base05,
    hint = palette.base0C,
  }

  -- See: |diagnostic-highlights|
  hi.DiagnosticOk = { fg = d.ok }
  hi.DiagnosticError = { fg = d.error }
  hi.DiagnosticWarn = { fg = d.warn }
  hi.DiagnosticInfo = { fg = d.info }
  hi.DiagnosticHint = { fg = d.hint }

  hi.DiagnosticFloatingOk = "DiagnosticOk"
  hi.DiagnosticFloatingError = "DiagnosticError"
  hi.DiagnosticFloatingWarn = "DiagnosticWarn"
  hi.DiagnosticFloatingInfo = "DiagnosticInfo"
  hi.DiagnosticFloatingHint = "DiagnosticHint"

  -- hi.DiagnosticVirtualTextOk = "DiagnosticOk"
  -- hi.DiagnosticVirtualTextError = "DiagnosticError"
  -- hi.DiagnosticVirtualTextWarn = "DiagnosticWarn"
  -- hi.DiagnosticVirtualTextInfo = "DiagnosticInfo"
  -- hi.DiagnosticVirtualTextHint = "DiagnosticHint"

  hi.DiagnosticUnderlineOk = { sp = d.ok, undercurl = true }
  hi.DiagnosticUnderlineError = { sp = d.error, undercurl = true }
  hi.DiagnosticUnderlineWarn = { sp = d.warn, undercurl = true }
  hi.DiagnosticUnderlineInfo = { sp = d.info, undercurl = true }
  hi.DiagnosticUnderlineHint = { sp = d.hint, undercurl = true }
  -- hi.DiagnosticUnnecessary = "Comment"
end

return M
