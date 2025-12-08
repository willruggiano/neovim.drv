return function()
  ---@diagnostic disable-next-line: undefined-field
  require("leap").setup {}

  ---@diagnostic disable-next-line: undefined-field
  require("leap").opts.equivalence_classes = {
    " \t\r\n",
    "([{",
    ")]}",
    "'\"`",
  }

  vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
  vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })

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
    end, { desc = "+remote" })
    vim.keymap.set({ "x", "o" }, "ir", function()
      remote_text_object "i"
    end, { desc = "+remote" })
  end

  -- Automatically paste when doing a remote yank operation.
  vim.api.nvim_create_autocmd("User", {
    pattern = "RemoteOperationDone",
    group = vim.api.nvim_create_augroup("LeapRemote", {}),
    callback = function(event)
      -- Do not paste if some special register was in use.
      if vim.v.operator == "y" and event.data.register == '"' then
        vim.cmd "normal! p"
      end
    end,
  })
end
