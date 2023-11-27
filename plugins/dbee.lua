return function()
  require("dbee").setup {
    drawer = {
      disable_help = true,
    },
    editor = {
      mappings = {
        run_selection = {
          key = "<C-M>",
          mode = "x",
          opts = {
            expr = true,
          },
        },
      },
    },
    result = {
      mappings = {
        page_next = { key = "<C-n>", mode = "" },
        page_prev = { key = "<C-p>", mode = "" },
      },
    },
    sources = {
      require("dbee.sources").FileSource:new(vim.fn.getcwd() .. "/.db.json"),
    },
    ui = {
      -- I can manage my own window layouts thank you very much
      pre_open_hook = function() end,
      post_close_hook = function() end,
      window_commands = {
        drawer = function()
          vim.cmd "topleft 40vsplit"
          vim.api.nvim_set_option_value("relativenumber", false, {})
          vim.api.nvim_set_option_value("number", false, {})
          vim.api.nvim_set_option_value("signcolumn", "no", {})
          return vim.api.nvim_get_current_win()
        end,
      },
    },
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  nnoremap("<space>d", function()
    require("dbee").toggle()
  end, { desc = "[db] Toggle" })
end
