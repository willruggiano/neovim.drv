return function()
  require("neo-tree").setup {
    filesystem = {
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ["-"] = "navigate_up",
          ["."] = "toggle_hidden",
        },
      },
    },
    window = {
      position = "current",
      mappings = {
        o = "open",
        ["<C-s>"] = "open_split",
        ["<C-t>"] = "open_tabnew",
        ["<C-v>"] = "open_vsplit",
      },
    },
  }

  require("bombadil.lib.keymap").nnoremap("-", "<cmd>Neotree reveal<CR>", { desc = "Explore" })
end
