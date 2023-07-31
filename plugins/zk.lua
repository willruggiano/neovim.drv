return function()
  local zk = require "zk"

  zk.setup {}

  require("zk.commands").add("ZkNewDoc", function(options)
    zk.new(vim.tbl_extend("force", { dir = "docs" }, options))
  end)

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<space>z", function()
    zk.edit({}, { title = "Notes" })
  end, { desc = "Notes" })

  nnoremap("<leader>zi", zk.index, { desc = "Index notebook " })

  nnoremap("<leader>zn", function()
    zk.new { title = vim.fn.input "Title: " }
  end, { desc = "New note" })

  nnoremap("<leader>zf", function()
    local query = vim.fn.input "Query: "
    zk.edit({ sort = { "modified" }, match = query }, { title = string.format([[Notes matching "%s"]], query) })
  end, { desc = "Query notes" })

  vim.api.nvim_create_autocmd("Filetype", {
    pattern = "markdown",
    callback = function(opts)
      local bufnr = opts.buf
      require("bombadil.lib.keymap").buf_noremaps("n", {
        ["<leader>zb"] = {
          function()
            zk.edit({ linkTo = { vim.api.nvim_buf_get_name(bufnr) } }, { title = "Backlinks" })
          end,
          { desc = "Backlinks" },
        },
        ["<leader>zl"] = {
          function()
            zk.edit({ linkedBy = { vim.api.nvim_buf_get_name(bufnr) } }, { title = "Links" })
          end,
          { desc = "Links" },
        },
      })
    end,
  })
end
