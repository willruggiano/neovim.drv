return function()
  vim.opt.cmdheight = 1
  require("ivy").setup {
    backends = {
      {
        "ivy.backends.buffers",
        { keymap = "<space>b", description = "[ivy] buffers" },
      },
      {
        "ivy.backends.files",
        { keymap = "<space>o", description = "[ivy] files" },
      },
      {
        "ivy.backends.lines",
        { keymap = "<space>l", description = "[ivy] lines" },
      },
      {
        "ivy.backends.lsp-workspace-symbols",
        { keymap = "<space>s", description = "[ivy] symbols" },
      },
      {
        "ivy.backends.rg",
        { keymap = "<space>f", description = "[ivy] grep" },
      },
    },
  }
end
