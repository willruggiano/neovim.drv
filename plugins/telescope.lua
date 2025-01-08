return function()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  local themes = require "telescope.themes"

  local default_theme = themes.get_ivy {
    layout_config = { height = 0.25 },
    selection_caret = "* ",
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
          ["<C-x>"] = false,
          ["<D-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<M-q>"] = false,
        },
      },
      --
      previewer = false,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      --
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
      smart_open = {
        mappings = {
          i = {
            ["<C-w>"] = false,
          },
        },
        match_algorithm = "fzf",
      },
      undo = {
        mappings = {
          i = {
            ["<C-y>"] = false,
            ["<C-r>"] = false,
          },
        },
        side_by_side = true,
      },
    },

    pickers = {
      buffers = {
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
        },
      },
    },
  }

  telescope.load_extension "fzf"
  telescope.load_extension "smart_open"
  telescope.load_extension "ui-select"
  telescope.load_extension "undo"

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  local mappings = {
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
        require("telescope.builtin").live_grep()
      end,
      { desc = "[telescope] grep" },
    },
    ["<space>o"] = {
      function()
        require("telescope").extensions.smart_open.smart_open { cwd_only = true }
      end,
      { desc = "[telescope] files" },
    },
    ["<space>u"] = {
      function()
        require("telescope").extensions.undo.undo()
      end,
      { desc = "[telescope] undo" },
    },
  }

  for key, opts in pairs(mappings) do
    nnoremap(key, opts[1], opts[2])
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

      if client:supports_method "workspace/symbol" then
        vim.keymap.set("n", "<space>s", function()
          require("telescope.builtin").lsp_workspace_symbols()
        end, { buffer = bufnr, desc = "[lsp] workspace symbols" })
      end
    end,
  })
end
