return function()
  require("leap").setup {}
  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

  vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
  vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })

  -- Remote.
  vim.keymap.set({ "n", "x", "o" }, "gR", function()
    require("leap.remote").action()
  end, { desc = "Leap (remote)" })

  -- Create remote versions of all a/i text objects by inserting `r`
  -- into the middle (e.g. `iw` becomes `irw`).
  do
    local remote_text_object = function(prefix)
      local ok, ch = pcall(vim.fn.getcharstr) -- pcall for handling <C-c>
      if not ok or ch == vim.keycode "<esc>" then
        return
      end
      require("leap.remote").action { input = prefix .. ch }
    end
    vim.keymap.set({ "x", "o" }, "ar", function()
      remote_text_object "a"
    end)
    vim.keymap.set({ "x", "o" }, "ir", function()
      remote_text_object "i"
    end)
  end

  -- Automatically paste when doing a remote yank operation.
  vim.api.nvim_create_augroup("LeapRemote", {})
  vim.api.nvim_create_autocmd("User", {
    pattern = "RemoteOperationDone",
    group = "LeapRemote",
    callback = function(event)
      if vim.v.operator == "y" and event.data.register == "+" then
        vim.cmd "normal! p"
      end
    end,
  })
end
