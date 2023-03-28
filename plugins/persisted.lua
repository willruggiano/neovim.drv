return function()
  require("persisted").setup {
    silent = true,
    use_git_branch = true,
    autosave = false,
  }

  require("telescope").load_extension "persisted"
end
