return function()
  require("indent_blankline").setup {
    buftype_exclude = {
      "help",
      "nofile",
      "prompt",
      "quickfix",
      "terminal",
    },
    filetype_exclude = {
      "NeogitCommitView",
      "NeogitLogView",
      "NeogitStatus",
      "OverseerForm",
      "TelescopePrompt",
      "man",
      "packer",
      "vimcmake",
    },
  }

  local hi = require("flavours").highlight

  hi.IndentBlanklineChar = "base02_fg"
  hi.IndentBlanklineContextChar = "base04_fg"
end
