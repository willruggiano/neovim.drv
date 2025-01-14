return function()
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
    transient = true,
  }
end
