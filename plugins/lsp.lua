return function()
  local lsp = require "bombadil.lsp"

  --
  -- Styling
  --

  lsp.kind.init {
    symbol_map = {
      Copilot = "",
    },
  }

  ---@diagnostic disable-next-line: missing-parameter
  for type, icon in pairs(lsp.signs.get()) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  --
  -- Diagnostics
  --

  vim.diagnostic.config {
    float = {
      border = "single",
    },
    severity_sort = true,
    signs = false,
    underline = true,
    update_in_insert = false,
    virtual_text = {
      format = function(diagnostic)
        return string.format("%s  %s", lsp.signs.severity(diagnostic.severity), diagnostic.message)
      end,
      prefix = "",
      spacing = 4,
      suffix = function(diagnostic)
        return diagnostic.source and " [" .. diagnostic.source .. "]" or ""
      end,
    },
  }

  --
  -- Generic lsp configuration
  --

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have a valid client")

      if
        client:supports_method "textDocument/hover" or client.name == "dartls" -- FIXME: lmao wat
      then
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover { border = "single", wrap = false }
        end, { buffer = bufnr, desc = "[lsp] hover" })
      end

      if client:supports_method "textDocument/signatureHelp" then
        vim.keymap.set("i", "<C-s>", function()
          vim.lsp.buf.signature_help { border = "single", wrap = false }
        end, { buffer = bufnr, desc = "[lsp] signature help" })
      end

      if
        client:supports_method "textDocument/codeAction" or client.name == "dartls" -- FIXME: lmao wat
      then
        vim.keymap.set(
          "n",
          "<localleader>a",
          require("fastaction").code_action,
          { buffer = bufnr, desc = "[lsp] code action" }
        )
        vim.keymap.set(
          "v",
          "<localleader>a",
          [[<esc><cmd>lua require("fastaction").range_code_action()<cr>]],
          { buffer = bufnr, desc = "[lsp] code action" }
        )
      end

      if client:supports_method "textDocument/declaration" then
        vim.keymap.set("n", "gD", function()
          vim.lsp.buf.declaration { reuse_win = true }
        end, { buffer = bufnr, desc = "[lsp] goto declaration" })
      end

      if client:supports_method "textDocument/documentHighlight" then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved", "CursorMovedI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end

      if client:supports_method "textDocument/typeDefinition" then
        vim.keymap.set("n", "gT", function()
          vim.lsp.buf.type_definition { reuse_win = true }
        end, { buffer = bufnr, desc = "[lsp] typedef" })
      end

      if client:supports_method "workspace/symbol" then
        vim.keymap.set("n", "<space>s", function()
          vim.ui.input({ prompt = "Query> " }, function(query)
            vim.lsp.buf.workspace_symbol(query)
          end)
        end, { buffer = bufnr, desc = "[lsp] workspace symbols" })
      end
    end,
  })

  vim.lsp.enable {
    "basedpyright",
    "bashls",
    "biome",
    "clangd",
    "cmake",
    "dartls",
    "efm",
    "elmls",
    "emmylua_ls",
    "graphql",
    "hls",
    "jsonls",
    -- "lua_ls",
    "marksman",
    "mdx_analyzer",
    "nginx_language_server",
    "nil_ls",
    "postgres_lsp",
    "prismals",
    -- "relay_lsp",
    "ruff",
    "rust_analyzer",
    -- "sqruff",
    "superhtml",
    "tsp_server",
    "vtsls",
    "yamlls",
    "zls",
  }
end
