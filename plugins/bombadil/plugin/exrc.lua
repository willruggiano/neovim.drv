if vim.secure.read ".nvim.lua" then
  vim.cmd.luafile ".nvim.lua"
end
