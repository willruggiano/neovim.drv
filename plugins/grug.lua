return function()
  vim.api.nvim_create_user_command("Float", function()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(bufnr, true, {
      border = "single",
      style = "minimal",
      relative = "editor",
      height = vim.o.lines,
      width = math.floor(vim.o.columns * 0.3),
      row = 0,
      col = vim.o.columns - 1,
    })
  end, {})

  local grug = require "grug-far"
  grug.setup {
    debounceMs = 250,
    engines = {
      astgrep = {
        path = "ast-grep",
      },
    },
    keymaps = {
      close = { n = "q" },
      openNextLocation = { n = "<C-n>" },
      openPrevLocation = { n = "<C-p>" },
      previewLocation = false,
    },
    startInInsertMode = false,
    transient = true,
    windowCreationCommand = "Float",
  }

  local noremap = require("bombadil.lib.keymap").noremap
  local instanceName = "global"

  noremap({ "n", "v" }, "<space>f", function()
    if vim.fn.mode():lower():find "v" ~= nil then
      -- Kill the existing instance, if any, in visual mode as we expect the
      -- visual selection to have changed
      grug.kill_instance(instanceName)
    end
    if grug.has_instance(instanceName) then
      -- If the global instance exists, open it
      grug.open_instance(instanceName)
    else
      -- Otherwise go through the normal entrypoint
      grug.open { instanceName = instanceName }
    end
  end, { desc = "Find" })
end
