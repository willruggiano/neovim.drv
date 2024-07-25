return function()
  local kulala = require "kulala"
  kulala.setup()

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  vim.filetype.add {
    extension = {
      http = function()
        return "http",
          function(bufnr)
            nnoremap("<CR>", kulala.run, { buffer = bufnr, desc = "Run the current request" })
            nnoremap(
              "<leader>tv",
              kulala.toggle_view,
              { buffer = bufnr, desc = "Toggle between body and headers view" }
            )
            nnoremap("]]", kulala.jump_next, { buffer = bufnr, desc = "Goto next request" })
            nnoremap("][", kulala.jump_prev, { buffer = bufnr, desc = "Goto previous request" })
            nnoremap("yab", kulala.copy, { buffer = bufnr, desc = "Yank current request" })
          end
      end,
    },
  }
end
