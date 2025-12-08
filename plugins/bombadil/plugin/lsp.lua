--
-- Diagnostics
--

vim.diagnostic.config {
  severity_sort = true,
  signs = false,
  underline = true,
  update_in_insert = false,
  -- virtual_text = function(ns, bufnr)
  --   vim.diagnostic.get(bufnr, { namespace = ns })
  -- end,
  virtual_text = {
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

    if client:supports_method "textDocument/completion" then
      ---@diagnostic disable-next-line: need-check-nil
      client.server_capabilities.completionProvider.triggerCharacters = {}
      vim.lsp.completion.enable(true, client.id, bufnr, {})
    end

    if client:supports_method "textDocument/declaration" then
      vim.keymap.set("n", "grd", function()
        vim.lsp.buf.declaration { reuse_win = true }
      end, { buffer = bufnr, desc = "vim.lsp.buf.declaration()" })
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

    if client:supports_method "textDocument/hover" then
      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover { max_width = 50 }
      end, { buffer = bufnr, desc = "vim.lsp.buf.hover()" })
    end

    if client:supports_method "workspace/symbol" then
      vim.keymap.set("n", "<space>s", function()
        vim.ui.input({ prompt = "Query> " }, function(query)
          vim.lsp.buf.workspace_symbol(query)
        end)
      end, { buffer = bufnr, desc = "vim.lsp.buf.workspace_symbols()" })
    end
  end,
})

-- We only enable a few by default.
-- In general I feel that these should be enabled at the project level.
vim.lsp.enable {
  "bashls",
  "efm",
  "emmylua_ls",
  "jsonls",
  "marksman",
  "nil_ls",
  "superhtml",
  "yamlls",
}
