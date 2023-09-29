return function()
  vim.g.db_ui_use_nvim_notify = 1

  require("cmp").setup.filetype({ "mysql", "plsql", "sql" }, {
    sources = {
      { name = "vim-dadbod-completion" },
    },
  })

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  local xnoremap = require("bombadil.lib.keymap").xnoremap

  nnoremap("<space>d", function()
    vim.api.nvim_cmd({
      cmd = "DBUIToggle",
      mods = {
        silent = true,
      },
    }, {})
  end, { desc = "[dadbod] Toggle" })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function(opts)
      xnoremap("<C-M>", "db#op_exec()", { buffer = opts.buf, desc = "[dadbod] Run selected query", expr = true })
    end,
  })
end
