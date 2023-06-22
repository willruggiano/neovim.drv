return function()
  vim.cmd.colorscheme "flavours"

  local vim_to_sys = {
    [vim.log.levels.TRACE] = "low",
    [vim.log.levels.DEBUG] = "low",
    [vim.log.levels.INFO] = "normal",
    [vim.log.levels.WARN] = "normal",
    [vim.log.levels.ERROR] = "critical",
  }

  local notify = vim.notify
  local function notify_send(msg, level, opts)
    if not pcall(os.execute, string.format("notify-send -u %s Neovim '%s'", vim_to_sys[level], msg)) then
      notify(msg, level, opts)
    end
  end

  local notifiers = {
    [vim.log.levels.WARN] = notify_send,
    [vim.log.levels.ERROR] = notify_send,
  }
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(msg, level, opts)
    (notifiers[level] or notify)(msg, level, opts)
  end
end
