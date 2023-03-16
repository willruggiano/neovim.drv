vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "CargoExpand", function(args)
  require("cargo-expand").expand {
    args = vim.list_extend({ "expand" }, args.fargs or {}),
  }
end, { nargs = "*" })
