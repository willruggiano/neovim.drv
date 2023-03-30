local ffi = require "ffi"
ffi.cdef [[
  int getuid(void);
]]

local lfs = require "lfs"

local function exists(file)
  return lfs.attributes(file) ~= nil
end

local function owned_by_me(file)
  return ffi.C.getuid() == lfs.attributes(file).uid
end

if exists ".nvim" then
  local cwd = lfs.currentdir()
  for filename in vim.fs.dir ".nvim" do
    local file = cwd .. "/.nvim/" .. filename
    if owned_by_me(file) then
      dofile(file)
    else
      print(filename .. " exists but was not loaded; security reason: a different owner")
    end
  end
end
