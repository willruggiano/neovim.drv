vim.filetype.add {
  extension = {
    snippet = "snip",
    xit = "xit",
    ixx = "cpp",
    mxx = "cpp",
    txx = "cpp",
  },
  filename = {
    [".clang-format"] = "yaml",
    ["flake.lock"] = "json",
    ["git-rebase-todo"] = "gitrebase",
  },
}
