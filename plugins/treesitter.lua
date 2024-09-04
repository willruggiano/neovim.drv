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

  local highlights = {
    -- cpp = {
    --   ["alias.name"] = "Variable",
    --   ["alias.type"] = "Type",
    --   ["function.return"] = "Keyword",
    --   ["function.parameter_type"] = "Keyword",
    -- },
    -- lua = {
    --   -- ["repeat"] = "Keyword",
    -- },
    markdown_inline = {
      ["text.emphasis"] = { italic = true },
      ["text.strike"] = { strikethrough = true },
      ["text.strong"] = { bold = true },
    },
    -- rust = {
    --   ["storageclass.lifetime"] = "String",
    --   ["type.qualifier"] = "Keyword",
    -- },
    zig = {
      ["attribute"] = "@keyword",
      ["type.qualifier"] = "@keyword",
    },
  }

  local hi = require("flavours").highlight
  for lang, maps in pairs(highlights) do
    for group, opts in pairs(maps) do
      hi["@" .. group .. "." .. lang] = opts
    end
  end
end
