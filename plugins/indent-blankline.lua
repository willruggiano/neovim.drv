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
      "TelescopePrompt",
      "firvish",
      "man",
      "packer",
      "vimcmake",
    },
  }

  local hi = require("flavours").highlight
  local palette = require "flavours.palette"

  hi.IndentBlanklineChar = { fg = palette.base02, nocombine = true }
  hi.IndentBlanklineContextChar = { fg = palette.base04, nocombine = true }
end
