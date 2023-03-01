local bufdelete = require("bufdelete").bufdelete

local delete_buffer = function(bufnr)
  if vim.fn.bufwinnr(bufnr) ~= -1 then
    bufdelete(bufnr, true)
  else
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

local function is_listed(bufnr)
  local buflisted = vim.api.nvim_buf_get_option(bufnr, "buflisted")
  return buflisted == true
end

local list_loaded_buffers = function()
  local bufs = vim.api.nvim_list_bufs()
  local loaded = {}
  for _, b in ipairs(bufs) do
    if string.find(vim.fn.bufname(b), "Wilder") then
      -- Don't count wilder.nvim buffers
    elseif is_listed(b) then
      table.insert(loaded, b)
    end
  end
  return loaded
end

local is_nameless_buffer = function(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  return bufname == ""
end

local list_visible_buffers = function()
  local visible = {}
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    table.insert(visible, vim.api.nvim_win_get_buf(w))
  end
  return visible
end

return {
  delete = delete_buffer,
  loaded = list_loaded_buffers,
  nameless = is_nameless_buffer,
  visible = list_visible_buffers,
}
