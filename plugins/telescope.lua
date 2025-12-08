return function()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local themes = require "telescope.themes"
  local lga = require "telescope-live-grep-args.actions"

  local default_theme = themes.get_ivy {
    layout_config = { height = 0.25 },
    selection_caret = "* ",
  }
  local cursor_theme = themes.get_cursor {
    previewer = false, -- this is usually the case
  }

  telescope.setup {
    defaults = vim.tbl_deep_extend("force", default_theme, {
      mappings = {
        i = {
          ["<C-c>"] = actions.close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = false,
          ["<C-p>"] = false,
          ["<C-s>"] = actions.select_horizontal,
          ["<C-space>"] = actions.to_fuzzy_refine,
          ["<C-x>"] = false,
          ["<D-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<M-q>"] = false,
        },
      },
      previewer = false,
      prompt_title = false,
      results_title = false,
    }),

    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      live_grep_args = {
        auto_quoting = true,
        mappings = {
          i = {
            ["<CR>"] = actions.select_drop + actions.center,
            ["<C-'>"] = lga.quote_prompt(),
            ["<C-i>"] = lga.quote_prompt { postfix = " --iglob " },
          },
          n = {
            ["<CR>"] = actions.select_drop + actions.center,
          },
        },
      },
      smart_open = {
        mappings = {
          i = {
            ["<CR>"] = actions.select_drop,
            ["<C-w>"] = false,
          },
          n = {
            ["<CR>"] = actions.select_drop,
          },
        },
        match_algorithm = "fzf",
      },
    },

    pickers = {
      buffers = {
        mappings = {
          i = {
            ["<CR>"] = actions.select_drop + actions.center,
            ["<C-d>"] = "delete_buffer",
            ["<C-y>"] = "select_default",
          },
          n = {
            ["<CR>"] = actions.select_drop + actions.center,
          },
        },
      },
      lsp_document_symbols = {
        mappings = {
          i = {
            ["<CR>"] = actions.select_drop + actions.center,
          },
          n = {
            ["<CR>"] = actions.select_drop + actions.center,
          },
        },
      },
    },
  }

  telescope.load_extension "fzf"
  telescope.load_extension "live_grep_args"
  telescope.load_extension "smart_open"
  telescope.load_extension "ui-select"

  local mappings = {
    ["n"] = {
      ["<leader>e"] = {
        function()
          require("telescope.builtin").symbols()
        end,
        { desc = "🚀" },
      },
      ["<space>b"] = {
        function()
          require("telescope.builtin").buffers()
        end,
        { desc = "Buffers" },
      },
      ["<space>h"] = {
        function()
          require("telescope.builtin").help_tags()
        end,
        { desc = "[telescope] help tags" },
      },
      ["<space>f"] = {
        function()
          ---@diagnostic disable-next-line: undefined-field
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        { desc = "[telescope] grep" },
      },
      ["<space>o"] = {
        function()
          ---@diagnostic disable-next-line: undefined-field
          require("telescope").extensions.smart_open.smart_open { cwd_only = true }
        end,
        { desc = "[telescope] files" },
      },
    },
    ["i"] = {
      ["<c-f>"] = {
        function()
          require("telescope.builtin").find_files(themes.get_cursor {
            attach_mappings = function(_, map)
              map("i", "<CR>", function(prompt_bufnr)
                local symbol = action_state.get_selected_entry().value
                actions.close(prompt_bufnr)
                vim.schedule(function()
                  vim.api.nvim_put({ symbol }, "", true, true)
                end)
              end)
              return true
            end,
            previewer = false, -- this is usually the case
          })
        end,
        { desc = "[telescope] insert filepath" },
      },
    },
    [{ "x", "n" }] = {
      ["<leader>f"] = {
        function()
          require("telescope.builtin").grep_string(cursor_theme)
        end,
        { desc = "🔍" },
      },
    },
  }

  for mode, mapping in pairs(mappings) do
    for lhs, map in pairs(mapping) do
      vim.keymap.set(mode, lhs, map[1], vim.tbl_extend("keep", map[2] or {}, { noremap = true, silent = true }))
    end
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have a valid client")

      if client:supports_method "textDocument/documentSymbol" then
        vim.keymap.set("n", "gO", function()
          require("telescope.builtin").lsp_document_symbols()
        end, { buffer = bufnr, desc = "[lsp] document symbols" })
      end
    end,
  })
end
