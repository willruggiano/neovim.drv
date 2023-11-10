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
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  nnoremap("<space>d", function()
    require("dbee").toggle()
  end, { desc = "[db] Toggle" })
end
