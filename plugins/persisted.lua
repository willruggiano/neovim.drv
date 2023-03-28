return function()
  require("persisted").setup {
    silent = true,
    use_git_branch = true,
    autosave = false,
  }

  require("telescope").load_extension "persisted"

  vim.api.nvim_create_user_command("Sessions", function()
    require("telescope").extensions.persisted.persisted()
  end, { desc = "List sessions" })
end
