return function(bufnr)
  local has_cmp, cmp = pcall(require, "cmp")
  if has_cmp then
    vim.api.nvim_buf_call(bufnr, function()
      cmp.setup.buffer { sources = { { name = "crates" } } }
    end)
  end

  local has_crates, crates = pcall(require, "crates")
  if has_crates then
    local commands = {
      CargoReload = crates.reload,
      CargoVersions = crates.show_versions_popup,
      CargoFeatures = crates.show_features_popup,
      CargoDeps = crates.show_dependencies_popup,
      CargeUpdateOne = crates.update_crate,
      CargoUpdateSelected = crates.update_crates,
      CargoUpdateAll = crates.update_all_crates,
      CargoOpenRepo = crates.open_repository,
      CargoOpenDocs = crates.open_documentation,
    }
    for k, v in pairs(commands) do
      vim.api.nvim_buf_create_user_command(bufnr, k, v, {})
    end

    vim.keymap.set("n", "K", crates.show_popup, { buffer = bufnr })
  end
end
