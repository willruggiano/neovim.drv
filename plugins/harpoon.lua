return function()
  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<space><cr>", function()
    require("harpoon.ui").toggle_quick_menu()
  end, { desc = "Harpoon" })

  nnoremap("<leader>ma", function()
    require("harpoon.mark").add_file()
  end, { desc = "Mark file" })

  vim.filetype.add {
    harpoon = function()
      return "harpoon",
        function(bufnr)
          for k, v in pairs { signcolumn = "no" } do
            vim.api.nvim_buf_set_option(bufnr, k, v)
          end
        end
    end,
  }

  local hi = require("flavours").highlight

  hi.HarpoonWindow = "Normal"
  hi.HarpoonBorder = "Normal"
end
