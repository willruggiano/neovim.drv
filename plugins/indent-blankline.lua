return function()
  require("ibl").setup {
    exclude = {
      buftypes = {
        "help",
        "nofile",
        "prompt",
        "quickfix",
        "terminal",
      },
      filetypes = {
        "NeogitCommitView",
        "NeogitLogView",
        "NeogitStatus",
        "OverseerForm",
        "TelescopePrompt",
        "man",
        "packer",
        "vimcmake",
      },
    },
    indent = {
      -- highlight = "base02_fg",
      char = "⦙",
    },
    scope = { enabled = false },
  }
end
