return function()
  vim.g.sqlite_clib_path = package.searchpath("libsqlite3", package.cpath)
end
