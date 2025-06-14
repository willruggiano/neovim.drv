return function()
  local use_ts_indent = false
  if use_ts_indent then
    vim.opt.autoindent = false
    vim.opt.cindent = false
  end

  require("nvim-treesitter.configs").setup {
    -- NOTE: Parsers are installed by nix.
    auto_install = false,

    highlight = {
      enable = true,
      disable = { "zig" },
    },

    indent = {
      enable = use_ts_indent,
    },

    matchup = {
      enable = true,
    },

    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },

    textobjects = {
      lsp_interop = {
        enable = true,
        border = "single",
        peek_definition_code = {
          ["gK"] = "@*",
        },
      },
      select = {
        enable = true,
        keymaps = {
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
        },
      },
    },
  }

  -- Python overrides.
  -- `import foo`
  --         ^^^ @lsp.type.namespace.python
  vim.api.nvim_set_hl(0, "@lsp.type.namespace.python", { link = "Type", force = true })
end
