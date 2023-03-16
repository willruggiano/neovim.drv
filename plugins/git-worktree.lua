return function()
  require("git-worktree").setup {}

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<leader>gwc", function()
    -- TODO: I don't like having to manually specify the path to the worktree.
    require("telescope").extensions.git_worktree.create_git_worktree()
  end, { desc = "Create worktree" })

  nnoremap("<leader>gwl", function()
    require("telescope").extensions.git_worktree.git_worktrees()
  end, { desc = "List worktrees" })
end
