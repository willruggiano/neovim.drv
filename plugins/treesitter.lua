return function()
  -- otherwise: No parser for language "typescriptreact"
  vim.treesitter.language.register("tsx", "typescriptreact")
end
