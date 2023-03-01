local keymap = vim.keymap

local noremap = { noremap = true, silent = true }

local with_opts = function(default, overrides)
  return vim.tbl_extend("force", default or {}, overrides or {})
end

local with_buffer = function(opts)
  return with_opts({ buffer = vim.api.nvim_get_current_buf() }, opts)
end

local M = {}

---Apply a mapping
---By default, opts are `{ noremap = true, silent = true }`
---@param modes string|table the modes to apply mappings for
---@param lhs string left-hand side of the mapping
---@param rhs string|function right-hand side of the mapping
---@param opts table?
---@see vim.keymap.set
M.noremap = function(modes, lhs, rhs, opts)
  keymap.set(modes, lhs, rhs, with_opts(noremap, opts))
end

---Shorthand for `noremap` but buffer local
---@see M.noremap
M.buf_noremap = function(modes, lhs, rhs, opts)
  M.noremap(modes, lhs, rhs, with_buffer(opts))
end

---Apply a set of mappings
---@param modes string|table the modes to apply mappings for
---@param mappings table a table of the form: { <lhs> = { <rhs>, [<opts>] }
---@param opts table? options to apply to all mappings
M.noremaps = function(modes, mappings, opts)
  opts = opts or {}
  for lhs, mapping in pairs(mappings) do
    M.noremap(modes, lhs, mapping[1], with_opts(mapping[2], opts))
  end
end

---Shorthand for `noremaps` but buffer local
---@see M.noremaps
M.buf_noremaps = function(modes, mappings, opts)
  M.noremaps(modes, mappings, with_buffer(opts))
end

local functions = {
  i = "inoremap",
  n = "nnoremap",
  t = "tnoremap",
  v = "vnoremap",
  x = "xnoremap",
}
local proto = {}

for mode, name in pairs(functions) do
  M[name] = function(lhs, rhs, opts)
    M.noremap(mode, lhs, rhs, opts)
  end

  M["buf_" .. name] = function(lhs, rhs, opts)
    M.buf_noremap(mode, lhs, rhs, opts)
  end
end

return M
