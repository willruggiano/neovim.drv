return function()
  require("leap").setup {}
  require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

  vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
  vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })

  vim.keymap.set({ "n", "x", "o" }, "ga", function()
    require("leap.treesitter").select()
  end, { desc = "Leap (AST)" })

  -- Linewise.
  vim.keymap.set(
    { "n", "x", "o" },
    "gA",
    'V<cmd>lua require("leap.treesitter").select()<cr>',
    { desc = "Leap (AST/linewise)" }
  )

  -- Remote.
  vim.keymap.set({ "n" }, "gR", function()
    require("leap.remote").action()
  end, { desc = "Leap (remote)" })

  -- Op pending remote textobjects
  local default_text_objects = {
    "iw",
    "iW",
    "is",
    "ip",
    "i[",
    "i]",
    "i(",
    "i)",
    "ib",
    "i>",
    "i<",
    "it",
    "i{",
    "i}",
    "iB",
    'i"',
    "i'",
    "i`",
    "aw",
    "aW",
    "as",
    "ap",
    "a[",
    "a]",
    "a(",
    "a)",
    "ab",
    "a>",
    "a<",
    "at",
    "a{",
    "a}",
    "aB",
    'a"',
    "a'",
    "a`",
  }
  -- Create remote versions of all native text objects by inserting `r`
  -- into the middle (`iw` becomes `irw`, etc.):
  for _, tobj in ipairs(default_text_objects) do
    vim.keymap.set({ "x", "o" }, tobj:sub(1, 1) .. "r" .. tobj:sub(2), function()
      require("leap.remote").action { input = tobj }
    end, { desc = "remote " .. tobj })
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
