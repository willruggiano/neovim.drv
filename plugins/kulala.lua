return function()
  local kulala = require "kulala"
  kulala.setup {
    scratchpad_default_contents = {
      "POST http://localhost:4000 HTTP/1.1",
      "accept: application/json",
      "content-type: application/json",
      "# @graphql 1",
      "",
      "query IntrospectionQuery {",
      "  __schema {",
      "    queryType { name }",
      "    mutationType { name }",
      "    subscriptionType { name }",
      "    directives {",
      "      name",
      "      description",
      "      locations",
      "    }",
      "  }",
      "}",
      "{}",
    },
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<leader>tc", kulala.scratchpad, { desc = "Toggle curl scratchpad" })

  local function on_attach(bufnr)
    nnoremap("<CR>", kulala.run, { buffer = bufnr, desc = "Run the current request" })
    nnoremap(".", kulala.replay, { buffer = bufnr, desc = "Replay the last run request" })
    nnoremap("<leader>tv", kulala.toggle_view, { buffer = bufnr, desc = "Toggle between body and headers view" })
    nnoremap("]]", kulala.jump_next, { buffer = bufnr, desc = "Goto next request" })
    nnoremap("][", kulala.jump_prev, { buffer = bufnr, desc = "Goto previous request" })
    nnoremap("yab", kulala.copy, { buffer = bufnr, desc = "Yank current request" })
  end
  vim.filetype.add {
    extension = {
      http = function()
        return "http", on_attach
      end,
    },
    filename = {
      ["kulala://scratchpad"] = function()
        return "http", on_attach
      end,
    },
  }
end
