return function()
  local telescope = require "telescope"
  telescope.load_extension "gh"

  require("litee.lib").setup()
  require("litee.gh").setup()

  local diff = require "litee.gh.pr.diff_view"
  local pr = require "litee.gh.pr"
  local pr_handlers = require "litee.gh.pr.handlers"
  local issues = require "litee.gh.issues"

  local prefix = "<leader>gh"
  local mappings = {
    [prefix .. "a"] = {
      function()
        require("gh-actions").open()
      end,
      { desc = "actions" },
    },
    [prefix .. "cc"] = {
      pr.close_pr_commits,
      { desc = "close" },
    },
    [prefix .. "ce"] = {
      pr.expand_pr_commits,
      { desc = "expand" },
    },
    [prefix .. "co"] = {
      pr.open_to_pr_files,
      { desc = "open" },
    },
    [prefix .. "cp"] = {
      pr.popout_to_pr_files,
      { desc = "popout" },
    },
    [prefix .. "cz"] = {
      pr.collapse_pr_commits,
      { desc = "collapse" },
    },
    [prefix .. "g"] = {
      function()
        require("telescope").extensions.gh.gist()
      end,
      { desc = "gists" },
    },
    [prefix .. "i"] = {
      function()
        require("telescope").extensions.gh.issues()
      end,
      { desc = "issues" },
    },
    [prefix .. "ip"] = {
      issues.preview_issue_under_cursor,
      { desc = "preview" },
    },
    [prefix .. "lt"] = {
      "<cmd>LTPanel<cr>",
      { desc = "toggle panel" },
    },
    [prefix .. "p"] = {
      function()
        require("telescope").extensions.gh.pr()
      end,
      { desc = "pull requests" },
    },
    [prefix .. "pc"] = {
      pr.close_pull,
      { desc = "close" },
    },
    [prefix .. "pd"] = {
      pr.open_pr_buffer,
      { desc = "details" },
    },
    [prefix .. "pe"] = {
      pr.expand_pr,
      { desc = "expand" },
    },
    [prefix .. "po"] = {
      pr.open_pull,
      { desc = "open" },
    },
    [prefix .. "pp"] = {
      pr.popout_to_pr,
      { desc = "pop out" },
    },
    [prefix .. "pr"] = {
      pr_handlers.on_refresh,
      { desc = "refresh" },
    },
    [prefix .. "pt"] = {
      pr.open_to_pr,
      { desc = "open to" },
    },
    [prefix .. "pz"] = {
      pr.collapse_pr,
      { desc = "collapse" },
    },
    [prefix .. "rb"] = {
      pr.start_review,
      { desc = "begin" },
    },
    [prefix .. "rc"] = {
      pr.close_pr_review,
      { desc = "close" },
    },
    [prefix .. "rd"] = {
      pr.delete_review,
      { desc = "delete" },
    },
    [prefix .. "re"] = {
      pr.expand_pr_review,
      { desc = "expand" },
    },
    [prefix .. "rs"] = {
      pr.submit_review,
      { desc = "submit" },
    },
    [prefix .. "rz"] = {
      pr.collapse_pr_review,
      { desc = "collapse" },
    },
    [prefix .. "tc"] = {
      diff.create_comment,
      { desc = "create" },
    },
    [prefix .. "tn"] = {
      diff.next_thread,
      { desc = "next" },
    },
    [prefix .. "tt"] = {
      diff.toggle_threads,
      { desc = "toggle" },
    },
    [prefix .. "w"] = {
      function()
        require("telescope").extensions.gh.run()
      end,
      { desc = "workflows" },
    },
  }

  require("bombadil.lib.keymap").noremaps("n", mappings)

  require("which-key").register({
    name = "+Hub",
    c = { name = "+Commits" },
    i = { name = "+Issues" },
    l = { name = "+Litee" },
    r = { name = "+Review" },
    p = { name = "+Pull Request" },
    t = { name = "+Threads" },
  }, { prefix = prefix })
end
