vim.filetype.add {
  filename = {
    ["Cargo.toml"] = function()
      return "cargo",
        function(bufnr)
          if vim.fn.executable "cargo" ~= 1 then
            return
          end

          vim.api.nvim_buf_create_user_command(bufnr, "Cargo", function(opts)
            require("bombadil.lib.job-control").run("cargo", opts.fargs or {}, opts.bang and "quickfix")
          end, { desc = "Cargo", bang = true, nargs = "*" })
        end
    end,
  },
}
