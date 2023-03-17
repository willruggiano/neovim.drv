vim.notify = function(msg, level, opts)
  os.execute('notify-send "[neovim]: ' .. msg .. '"')
end
