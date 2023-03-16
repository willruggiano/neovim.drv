if vim.fn.executable "cmake" ~= 1 then
  return
end

vim.api.nvim_create_user_command("CMake", function(opts)
  require("bombadil.lib.job-control").run("cmake", opts.fargs or {}, opts.bang and "quickfix")
end, { desc = "CMake", bang = true, nargs = "*" })
