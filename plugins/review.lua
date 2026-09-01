return function()
  local hi = require "bombadil.lib.highlight"

  hi.CodeDiffCharInsert = "DiffAdd"
  hi.CodeDiffCharDelete = "DiffDelete"
  hi.CodeDiffLineInsert = "DiffAdd"
  hi.CodeDiffLineDelete = "DiffDelete"
end
