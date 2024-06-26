return function()
  local noremap = require("bombadil.lib.keymap").noremap
  local nnoremap = require("bombadil.lib.keymap").nnoremap

  local signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  }

  local function nav_hunk(g, d)
    return function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        g.nav_hunk(d, { navigation_message = false, target = "all" })
      end)
      return "<Ignore>"
    end
  end

  require("gitsigns").setup {
    signs = signs,
    signs_staged = signs,
    numhl = false,
    on_attach = function(bufnr)
      local g = package.loaded.gitsigns

      nnoremap("]c", nav_hunk(g, "next"), { buffer = bufnr, expr = true, desc = "Next hunk" })
      nnoremap("[c", nav_hunk(g, "prev"), { buffer = bufnr, expr = true, desc = "Previous hunk" })
      noremap({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { buffer = bufnr, desc = "Stage hunk" })
      noremap({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { buffer = bufnr, desc = "Reset hunk" })
      nnoremap("<leader>hS", g.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
      nnoremap("<leader>hu", g.undo_stage_hunk, { buffer = bufnr, desc = "Unstage hunk" })
      nnoremap("<leader>hR", g.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
      nnoremap("<leader>hp", g.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
      nnoremap("<leader>hb", g.blame_line, { buffer = bufnr, desc = "Blame line" })
      nnoremap("<leader>hB", function()
        g.blame_line { full = true }
      end, { buffer = bufnr, desc = "Blame line (preview)" })
      noremap({ "o", "x" }, "ah", g.select_hunk, { buffer = bufnr, desc = "hunk" })
    end,
  }

  -- Not sure where these come from but they ugly :/
  local hi = require("flavours").highlight
  hi.Added = "DiffAdd"
  hi.Changed = "DiffChange"
  hi.Removed = "DiffDelete"
end
