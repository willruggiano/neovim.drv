return function()
  require("cmp").setup.filetype({ "mysql", "plsql", "sql" }, {
    sources = {
      { name = "vim-dadbod-completion" },
    },
  })
end
