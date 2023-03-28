return function()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local themes = require "telescope.themes"

  local set_prompt_to_entry_value = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if not entry or not type(entry) == "table" then
      return
    end

    action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
  end

  local common_dirs = {
    ["~/dev"] = "dev",
    ["~/notes"] = "notes",
    ["~/src"] = "src",
  }
  local project_dirs = {}
  for dir, _ in pairs(common_dirs) do
    ---@diagnostic disable-next-line: missing-parameter
    dir = vim.fn.expand(dir)
    if vim.fn.isdirectory(dir) == 1 then
      table.insert(project_dirs, dir)
    end
  end

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
          ["<C-s>"] = actions.select_horizontal,
          ["<C-x>"] = false,
          ["<C-y>"] = set_prompt_to_entry_value,
        },
      },

      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    }),

    extensions = {
      docsets = {
        query_command = "dasht-query-line",
      },

      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },

      project = {
        base_dirs = project_dirs,
      },
    },

    pickers = {
      buffers = {
        mappings = {
          n = {
            ["<C-d>"] = actions.delete_buffer,
          },
        },
      },
    },
  }

  telescope.load_extension "docsets"
  telescope.load_extension "fzf"
  telescope.load_extension "git_worktree"
  telescope.load_extension "project"
  telescope.load_extension "ui-select"

  if vim.fn.executable "gh" == 1 then
    telescope.load_extension "gh"
  end

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  local mappings = {
    ["<space>/"] = {
      function()
        require("telescope.builtin").help_tags()
      end,
      { desc = "Help tags" },
    },
    ["<space>e"] = {
      function()
        require("telescope.builtin").git_files()
      end,
      { desc = "Git files" },
    },
    ["<space>p"] = {
      function()
        require("telescope").extensions.project.project {}
      end,
      { desc = "Projects" },
    },
    ["<space>w"] = {
      function()
        require("telescope").extensions.arecibo.websearch { previewer = false }
      end,
      { desc = "Websearch" },
    },
    ["<leader>ghg"] = {
      function()
        require("telescope").extensions.gh.gist()
      end,
      { desc = "GitHub gists" },
    },
    ["<leader>ghi"] = {
      function()
        require("telescope").extensions.gh.issues()
      end,
      { desc = "GitHub issues" },
    },
    ["<leader>ghp"] = {
      function()
        require("telescope").extensions.gh.pull_request()
      end,
      { desc = "GitHub pull requests" },
    },
    ["<leader>ghw"] = {
      function()
        require("telescope").extensions.gh.run()
      end,
      { desc = "GitHub workflows" },
    },
    ["<space>k"] = {
      function()
        require("telescope").extensions.docsets.query { previewer = false }
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
