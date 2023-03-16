local compute_target_range_using_ts = function(location)
  local uri = location.targetUri or location.uri
  if uri == nil then
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local syntax = vim.api.nvim_buf_get_option(bufnr, "syntax")
  if syntax == "" then
    -- When no syntax is set, we use filetype as fallback. This might not result
    -- in a valid syntax definition. See also ft detection in stylize_markdown.
    -- An empty syntax is more common now with TreeSitter, since TS disables syntax.
    syntax = vim.api.nvim_buf_get_option(bufnr, "filetype")
  end
  local parser = vim.treesitter.get_parser(bufnr, syntax)
  local tree = parser:parse()[1]
  local range = location.targetRange or location.range
  range = { range.start.line, range.start.character, range["end"].line, range["end"].character }
  -- TODO: This will give us the signature of the definition, which is not what we need
  local target = tree:root():named_descendant_for_range(unpack(range))
  -- TODO: This doesn't quite work because it is language specific what is the true "target" node
  local parent = target:parent():parent():parent()
  local start_row, start_col, end_row, end_col = parent:range()
  if location.targetRange ~= nil then
    local target_range = location.targetRange
    target_range.start.line = start_row
    target_range.start.character = start_col
    target_range["end"].line = end_row
    target_range["end"].character = end_col
    location.targetRange = target_range
  else
    local target_range = location.range
    target_range.start.line = start_row
    target_range.start.character = start_col
    target_range["end"].line = end_row
    target_range["end"].character = end_col
    location.range = target_range
  end
  return location
end

local use_ts = true

local compute_target_range = function(location)
  if use_ts then
    return compute_target_range_using_ts(location)
  end
  local context = 15
  -- We need to change the range reported by the LSP (at least for clangd) since it only gives us
  -- the first line of the definition
  if location.targetRange ~= nil then
    local range = location.targetRange
    range["end"].line = range["end"].line + context
    location.targetRange = range
  else
    local range = location.range
    range["end"].line = range["end"].line + context
    location.range = range
  end
  return location
end

local preview_location = function(location, method)
  location = compute_target_range(location)
  return vim.lsp.util.preview_location(location, { border = "single" })
end

return function()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, ctx)
    if vim.tbl_islist(result) then
      preview_location(result[1], ctx.method)
    else
      preview_location(result, ctx.method)
    end
  end)
end
