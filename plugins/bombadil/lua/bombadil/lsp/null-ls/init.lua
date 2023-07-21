local custom_sources = { "alejandra", "jsonnet", "man", "prisma", "statix" }

local sources = {
  code_actions = {},
  diagnostics = {},
  formatting = {},
  hover = {},
}

for _, name in ipairs(custom_sources) do
  local custom_source = require("bombadil.lsp.null-ls." .. name)
  for action, source in pairs(custom_source) do
    sources[action][name] = source
  end
end

return sources
