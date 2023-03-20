return function()
  local noremap = require("bombadil.lib.keymap").noremap
  local nnoremap = require("bombadil.lib.keymap").nnoremap

  require("gitsigns").setup {
    signs = {
      add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr" },
      change = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr" },
      delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr" },
      topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr" },
      changedelete = { hl = "GitSignsDelete", text = "~", numhl = "GitSignsChangeNr" },
    },

    numhl = false,

    on_attach = function(bufnr)
      local gitsigns = package.loaded.gitsigns

      -- Navigation
      nnoremap("]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gitsigns.next_hunk()
        end)
        return "<Ignore>"
      end, { buffer = bufnr, expr = true, desc = "Next hunk" })

      nnoremap("[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gitsigns.prev_hunk()
        end)
        return "<Ignore>"
      end, { buffer = bufnr, expr = true, desc = "Previous hunk" })

      -- Actions
      noremap({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { buffer = bufnr, desc = "Stage hunk" })
      noremap({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { buffer = bufnr, desc = "Reset hunk" })
      nnoremap("<leader>hS", gitsigns.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
      nnoremap("<leader>hu", gitsigns.undo_stage_hunk, { buffer = bufnr, desc = "Unstage hunk" })
      nnoremap("<leader>hR", gitsigns.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
      nnoremap("<leader>hp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
      nnoremap("<leader>hb", function()
        gitsigns.blame_line { full = true }
      end, { buffer = bufnr, desc = "Blame line" })
      nnoremap("<leader>tb", gitsigns.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })
      nnoremap("<leader>hd", gitsigns.diffthis, { buffer = bufnr, desc = "Diff this" })
      nnoremap("<leader>hD", function()
        gitsigns.diffthis "~"
      end, { buffer = bufnr, desc = "Diff this" })
      nnoremap("<leader>td", gitsigns.toggle_deleted) -- Text object
      noremap({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", { buffer = bufnr, desc = "hunk" })
    end,
  }
end
