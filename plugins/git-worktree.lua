return function()
  require("git-worktree").setup {}

  local telescope = require "telescope"
  telescope.load_extension "git_worktree"

  local prefix = "<leader>gw"
  local mappings = {
    [prefix .. "c"] = {
      telescope.extensions.git_worktree.create_git_worktree,
      { desc = "create" },
    },
    [prefix .. "l"] = {
      telescope.extensions.git_worktree.git_worktrees,
      { desc = "list" },
    },
  }
  require("bombadil.lib.keymap").noremaps("n", mappings)

  require("which-key").register({
    name = "+Worktree",
  }, { prefix = prefix })
end
