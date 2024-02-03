return function()
  local icons = require "nvim-nonicons"

  require("neo-tree.sources.common.components").git_status = function(config, node, state)
    local git_status_lookup = state.git_status_lookup
    if config.hide_when_expanded and node.type == "directory" and node:is_expanded() then
      return {}
    end
    if not git_status_lookup then
      return {}
    end
    local git_status = git_status_lookup[node.path]
    if not git_status then
      if node.filtered_by and node.filtered_by.gitignored then
        git_status = "!!"
      else
        return {}
      end
    end

    local x = git_status:sub(1, 1)
    local y = git_status:sub(2, 2)
    return {
      {
        text = x,
        highlight = (x == "?" or x == "!") and "DiffDelete" or "DiffAdd",
      },
      {
        text = y,
        highlight = "DiffDelete",
      },
    }
  end

  require("neo-tree").setup {
    sources = { "filesystem" },
    enable_diagnostics = false,
    enable_open_markers = false,
    log_level = "error",
    popup_border_style = "single",
    use_popups_for_input = false,
    use_default_mappings = false,
    default_component_configs = {
      icon = {
        folder_closed = icons.get "file-directory",
        folder_open = icons.get "file-directory",
        folder_empty = icons.get "file-directory",
        folder_empty_open = icons.get "file-directory",
      },
      modified = {
        align = "left",
      },
      symlink_target = {
        enabled = true,
      },
    },
    window = {
      position = "current",
      insert_as = "sibling",
      same_level = true,
      mappings = {
        ["<cr>"] = "open",
        ["<C-s>"] = "open_split",
        ["<C-t>"] = "open_tabnew",
        ["<C-v>"] = "open_vsplit",
        ["o"] = "toggle_node",
        ["a"] = {
          "add",
          config = {
            show_path = "none", -- "none", "relative", "absolute"
          },
        },
        ["c"] = "copy",
        ["d"] = "delete",
        ["m"] = "move",
        ["q"] = "close_window",
        ["?"] = "show_help",
      },
    },
    filesystem = {
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ["."] = "toggle_hidden",
          ["-"] = "navigate_up",
          ["/"] = "fuzzy_finder",
          ["f"] = "filter_on_submit",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gu"] = "git_unstage_file",
          ["i"] = "show_file_details",
          ["<C-c>"] = "clear_filter",
          ["<C-.>"] = "set_root",
          ["[c"] = "prev_git_modified",
          ["]c"] = "next_git_modified",
        },
      },
    },
  }

  require("bombadil.lib.keymap").nnoremap("-", "<cmd>Neotree reveal<CR>", { desc = "Explore" })

  local hi = require("flavours").highlight
  hi.NeoTreeDimText = "Comment"
  hi.NeoTreeModified = "DiffChange"
end
