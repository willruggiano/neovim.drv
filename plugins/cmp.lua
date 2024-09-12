return function()
  vim.opt.completeopt = { "menu", "menuone", "noselect" }
  vim.opt.shortmess:append "c"

  local cmp = require "cmp"

  cmp.setup {
    sources = {
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "buffer" },
    },
    mapping = {
      ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      ["<C-y>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
      ),
      ["<C-space>"] = cmp.mapping {
        i = cmp.mapping.complete(),
      },
    },
    formatting = {
      format = require("lspkind").cmp_format {
        before = require("tailwind-tools.cmp").lspkind_format,
        mode = "symbol",
        maxwidth = 50,
        menu = {
          buffer = "[ buf]",
          cmp_git = "[ git]",
          cody = "[cody]",
          nvim_lsp = "[ lsp]",
          nvim_lua = "[nvim]",
          path = "[path]",
          shell = "[ sh]",
        },
      },
    },
  }

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })

  cmp.setup.filetype("gitcommit", {
    sources = {
      { name = "cmp_git" },
      { name = "buffer", group_index = 2 },
    },
  })
end
