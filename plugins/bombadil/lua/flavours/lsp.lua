local hi = require("flavours").highlight

local M = {}

function M.setup(palette)
  hi.LspReferenceRead = { sp = palette.base04, underline = true }
  hi.LspReferenceText = { sp = palette.base04, underline = true }
  hi.LspReferenceWrite = { sp = palette.base04, underline = true }
  -- TODO: These three:
  -- hi.LspCodeLens = { ... }
  -- hi.LspCodeLensSeparator = { ... }
  -- hi.LspSignatureActiveParameter = { ... }
end

return M
