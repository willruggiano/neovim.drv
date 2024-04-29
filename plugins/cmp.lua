return function()
  local cmp = require "cmp"
  local snippy = require "snippy"

  local cmp_buffer_locality_comparator = function(...)
    return require("cmp_buffer"):compare_locality(...)
  end
  local cmp_clangd_comparator = require "clangd_extensions.cmp_scores"
  local cmp_fuzzy_path_comparator = require "cmp_fuzzy_path.compare"
  local cmp_under_comparator = require("cmp-under-comparator").under

  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  require("cmp_git").setup()
  -- TODO: Enable these:
  -- require("cmp_shell").setup()
  -- require("nix-flake-prefetch.cmp").setup()

  cmp.setup {
    snippet = {
      expand = function(args)
        snippy.expand_snippet(args.body)
      end,
    },
    mapping = {
      ["<C-d>"] = cmp.mapping.scroll_docs(5),
      ["<C-u>"] = cmp.mapping.scroll_docs(-5),
      ["<C-c>"] = cmp.mapping.close(),
      ["<C-y>"] = function(fallback)
        if cmp.visible() then
          return cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }(fallback)
        else
          return fallback()
        end
      end,
      ["<C-space>"] = cmp.mapping {
        ---@diagnostic disable-next-line: missing-parameter
        i = cmp.mapping.complete(),
      },
      -- TODO: vim.snippet?
      ["<C-n>"] = cmp.mapping {
        i = function(fallback)
          if snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
          elseif cmp.visible() then
            return cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }(fallback)
          else
            return fallback()
          end
        end,
      },
      ["<C-p>"] = cmp.mapping {
        i = function(fallback)
          if snippy.can_jump(-1) then
            snippy.previous()
          elseif cmp.visible() then
            return cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }(fallback)
          else
            return fallback()
          end
        end,
      },
    },
    sources = cmp.config.sources({
      { name = "shell" },
      { name = "nix_flake_prefetch" },
    }, {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "snippy" },
      -- { name = "cody" },
    }, {
      { name = "path" },
      { name = "buffer" },
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        cmp_buffer_locality_comparator,
        cmp_fuzzy_path_comparator,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp_clangd_comparator,
        cmp_under_comparator,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    formatting = {
      format = require("lspkind").cmp_format {
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
          snippy = "[snip]",
        },
      },
    },
  }

  cmp.setup.filetype("gitcommit", {
    sources = {
      { name = "cmp_git" },
      { name = "buffer", group_index = 2 },
    },
  })
end
