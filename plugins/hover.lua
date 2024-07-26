return function()
  -- local util = require "vim.lsp.util"
  -- local utils = require "bombadil.lsp.utils"
  -- local m = vim.lsp.protocol.Methods

  -- FIXME: Don't quite work :(
  -- require("hover").register {
  --   name = "Definition",
  --   priority = 500,
  --   enabled = function(bufnr)
  --     local clients = vim.lsp.get_clients {
  --       bufnr = bufnr,
  --       method = m.textDocument_definition,
  --     }
  --     return #clients > 0
  --   end,
  --   execute = function(opts, done)
  --     local row, col = opts.pos[1] - 1, opts.pos[2]
  --     local params = utils.create_params(opts.bufnr, row, col)
  --     utils.buf_request_all(opts.bufnr, m.textDocument_definition, params, function(results)
  --       for _, result in pairs(results or {}) do
  --         if result.contents then
  --           local lines = util.convert_input_to_markdown_lines(result.contents)
  --           if not vim.tbl_isempty(lines) then
  --             done { lines = lines, filetype = "markdown" }
  --             return
  --           end
  --         end
  --       end
  --       -- no results
  --       done()
  --     end)
  --   end,
  -- }

  require("hover").setup {
    init = function()
      require "hover.providers.dap"
      require "hover.providers.diagnostic"
      require "hover.providers.dictionary"
      require "hover.providers.fold_preview"
      require "hover.providers.gh"
      require "hover.providers.lsp"
      require "hover.providers.man"
    end,
    title = false,
    mouse_providers = {},
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  nnoremap("K", require("hover").hover, { desc = "Hover" })
end
