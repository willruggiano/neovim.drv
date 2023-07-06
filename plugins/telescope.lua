return function()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  local themes = require "telescope.themes"

  local default_theme = themes.get_ivy {
    color_devicons = true,
    layout_config = { preview_cutoff = 150 },
    prompt_prefix = "> ",
    scroll_strategy = "cycle",
    selection_caret = "* ",
    selection_strategy = "reset",
    winblend = 5,
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
        },
      },

      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    }),

    extensions = {
      docsets = {
        query_command = "dasht-query-line",
        related = {
          typescript = { "javascript", "typescript" },
        },
      },
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      smart_open = {
        match_algorithm = "fzf",
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

  telescope.load_extension "docsets"
  telescope.load_extension "fzf"
  telescope.load_extension "smart_open"
  telescope.load_extension "ui-select"

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  local mappings = {
    ["<space>/"] = {
      function()
        require("telescope.builtin").help_tags()
      end,
      { desc = "Help tags" },
    },
    ["<space>b"] = {
      function()
        require("telescope.builtin").buffers()
      end,
      { desc = "Buffers" },
    },
    ["<space>o"] = {
      function()
        require("telescope").extensions.smart_open.smart_open()
      end,
      { desc = "Open Anything™" },
    },
    ["<space>k"] = {
      function()
        vim.ui.input({ prompt = "Query > " }, function(pattern)
          require("telescope").extensions.docsets.query(pattern, { previewer = false })
        end)
      end,
      { desc = "Docsets" },
    },
    ["<leader>k"] = {
      function()
        require("telescope").extensions.docsets.find_word_under_cursor { previewer = false }
      end,
      { desc = "Docsets CWORD" },
    },
  }

  for key, opts in pairs(mappings) do
    nnoremap(key, opts[1], opts[2])
  end
end
