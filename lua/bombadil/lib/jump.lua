return function(direction)
  local count = vim.v.count
  local bound = vim.g.jump_mark_bound or 5

  if count == 0 then
    vim.cmd("normal! g" .. direction)
    return
  end

  if count > bound then
    vim.cmd [[normal! m']]
  end

  vim.cmd("normal! " .. count .. direction)
end
