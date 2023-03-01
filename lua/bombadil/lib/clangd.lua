local M = {}

local util = require "lspconfig.util"

local function try_switch_source_header(bufnr, force, client, params)
  client.request("textDocument/switchSourceHeader", params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result and force then
      local uri = params.uri
      local ending = uri:sub(-3)
      local suffix = ending:sub(-2) -- e.g. "pp" in the cpp case, or xx in the cxx case
      if ending:sub(1, 2) == "c" then
        result = uri:sub(1, #uri - 3) .. "h" .. suffix
      else
        -- Else we assume a source file is what we want, which it usually is.
        result = uri:sub(1, #uri - 3) .. "c" .. suffix
      end
      -- But just to be sure prompt the user so they can make any changes, e.g. creating a .tpp from
      -- a .hpp instead of a source file
      vim.ui.input({ prompt = "", default = result, completion = "file" }, function(input)
        result = input
      end)
    end
    if not result then
      vim.notify("corresponding file cannot be determined", vim.log.levels.ERROR, { title = "clangd" })
      return
    end
    vim.api.nvim_command("edit " .. vim.uri_to_fname(result))
  end, bufnr)
end

M.switch_source_header = function(bufnr, force)
  bufnr = util.validate_bufnr(bufnr)

  local client = util.get_active_client_by_name(bufnr, "clangd")
  local params = { uri = vim.uri_from_bufnr(bufnr) }

  if client then
    try_switch_source_header(bufnr, force, client, params)
  else
    vim.notify(
      "method textDocument/switchSourceHeader is not supported by any servers active on the current buffer",
      vim.log.levels.ERROR,
      {
        title = "clangd",
      }
    )
  end
end

return M
