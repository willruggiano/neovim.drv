return function()
  require("dbee").setup {
    drawer = {
      disable_help = true,
    },
    editor = {
      mappings = {
        {
          action = "run_selection",
          key = "<C-M>",
          mode = "x",
          opts = { noremap = true, nowait = true, expr = true },
        },
      },
    },
    extra_helpers = {
      postgres = {
        -- Not really table-specific, see https://github.com/kndndrj/nvim-dbee/issues/66
        ["Active Queries"] = "SELECT pid, usename, age(clock_timestamp(), query_start) AS started_at, query FROM pg_stat_activity WHERE state = 'active' AND query NOT ILIKE '%pg_stat_activity%' ORDER BY query_start DESC;",
      },
    },
    result = {
      mappings = {
        { action = "cancel_call", key = "<C-c>", mode = "" },
        { action = "page_next", key = "<C-n>", mode = "" },
        { action = "page_prev", key = "<C-p>", mode = "" },
        { action = "yank_current_json", key = "yaj", mode = "n" },
        { action = "yank_selection_json", key = "yaj", mode = "v" },
        { action = "yank_all_json", key = "yaJ", mode = "" },
        { action = "yank_current_csv", key = "yac", mode = "n" },
        { action = "yank_selection_csv", key = "yac", mode = "v" },
        { action = "yank_all_csv", key = "yaC", mode = "" },
      },
    },
    sources = {
      require("dbee.sources").FileSource:new(vim.fn.getcwd() .. "/.db.json"),
    },
    -- window_layout = {
    --   -- I can manage my own window layouts thank you very much
    --   pre_open_hook = function() end,
    --   post_close_hook = function() end,
    --   window_commands = {
    --     drawer = function()
    --       vim.cmd "topleft 40vsplit"
    --       vim.api.nvim_set_option_value("relativenumber", false, {})
    --       vim.api.nvim_set_option_value("number", false, {})
    --       vim.api.nvim_set_option_value("signcolumn", "no", {})
    --       return vim.api.nvim_get_current_win()
    --     end,
    --   },
    -- },
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  nnoremap("<space>d", function()
    require("dbee").toggle()
  end, { desc = "[db] Toggle" })
end
