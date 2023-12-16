return function()
  local swap_next, swap_prev = (function()
    local swap_objects = {
      p = "@parameter.inner",
      f = "@function.outer",
      e = "@element",
      v = "@variable",
    }

    local n, p = {}, {}
    for key, obj in pairs(swap_objects) do
      n[string.format("<leader><leader>s%s", key)] = obj
      p[string.format("<leader><leader>s%s", string.upper(key))] = obj
    end

    return n, p
  end)()

  local use_ts_indent = false
  if use_ts_indent then
    vim.opt.autoindent = false
    vim.opt.cindent = false
  end

  local function make_textobject_query(query)
    return query
  end

  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup {
    -- NOTE: Parsers are installed by nix.
    ensure_installed = {},

    highlight = {
      enable = true,
    },

    indent = {
      enable = use_ts_indent,
    },

    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },

    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = false },
      smart_rename = { enable = false },
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        -- NOTE: Disable the init_selection mapping and only map the inc/dec/scope maps.
        -- We want to "init selection" through other means, e.g. unit/node selectors: vau, vaf, et al
        init_selection = "<nop>",
        node_incremental = "<c-u>", -- Increment to the upper named parent
        node_decremental = "<c-p>", -- Decrement to the previous node
        scope_incremental = "<c-s>", -- Increment to the upper scope (as defined in locals.scm)
      },
    },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },

    textobjects = {
      lsp_interop = {
        enable = true,
        border = "single",
        peek_definition_code = {
          ["gK"] = "@*",
        },
      },
      move = {
        enable = true,
        set_jumps = true,

        goto_next_start = {
          ["]]"] = make_textobject_query "@block.outer",
          ["]c"] = make_textobject_query "@class.outer",
          ["]f"] = make_textobject_query "@function.outer",
          ["]x"] = make_textobject_query "@comment",
        },
        goto_next_end = {
          ["]["] = make_textobject_query "@block.outer",
          ["]C"] = make_textobject_query "@class.outer",
          ["]F"] = make_textobject_query "@function.outer",
        },
        goto_previous_start = {
          ["[]"] = make_textobject_query "@block.outer",
          ["[c"] = make_textobject_query "@class.outer",
          ["[f"] = make_textobject_query "@function.outer",
          ["[x"] = make_textobject_query "@comment",
        },
        goto_previous_end = {
          ["[["] = make_textobject_query "@block.outer",
          ["[C"] = make_textobject_query "@class.outer",
          ["[F"] = make_textobject_query "@function.outer",
        },
      },
      select = {
        enable = true,
        keymaps = {
          ["ab"] = make_textobject_query "@block.outer",
          ["ib"] = make_textobject_query "@block.inner",
          ["af"] = make_textobject_query "@function.outer",
          ["if"] = make_textobject_query "@function.inner",
          ["ap"] = make_textobject_query "@parameter.outer",
          ["ip"] = make_textobject_query "@parameter.inner",
        },
      },
      swap = {
        enable = true,
        swap_next = swap_next,
        swap_previous = swap_prev,
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

  for lang, maps in pairs(highlights) do
    for group, link in pairs(maps) do
      local opts = type(link) == "table" and link or { link = link }
      vim.api.nvim_set_hl(0, "@" .. group .. "." .. lang, opts)
    end
  end

  local unit = require "treesitter-unit"

  -- Highlights the current treesitter "unit"
  -- Can be toggled with ,thu
  -- unit.enable_highlighting()

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  local noremap = require("bombadil.lib.keymap").noremap

  nnoremap("<leader>tu", unit.toggle_highlighting, { desc = "Toggle unit highlighting" })

  noremap({ "o", "x" }, "iu", [[:lua require("treesitter-unit").select()<cr>]], { desc = "inner unit" })
  noremap({ "o", "x" }, "au", [[:lua require("treesitter-unit").select(true)<cr>]], { desc = "outer unit" })
end
