return function()
  vim.opt.cmdheight = 1 -- ivy.nvim is really janky with cmdheight=0
  require("ivy").setup {
    backends = {
      { "ivy.backends.buffers", { keymap = "<space>b" } },
      { "ivy.backends.files", { keymap = "<space>o" } },
      { "ivy.backends.lines", { keymap = "<space>l" } },
      { "ivy.backends.lsp-workspace-symbols", { keymap = "<space>s" } },
      { "ivy.backends.rg", { keymap = "<space>f" } },
    },
  }
end
