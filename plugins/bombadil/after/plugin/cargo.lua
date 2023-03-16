vim.filetype.add {
  filename = {
    ["Cargo.toml"] = "cargo",
  },
}

if vim.fn.executable "cargo" ~= 1 then
  return
end

vim.api.nvim_create_user_command("Cargo", function(opts)
  require("bombadil.lib.job-control").run("cargo", opts.fargs or {}, opts.bang and "quickfix")
end, { desc = "Cargo", bang = true, nargs = "*" })
