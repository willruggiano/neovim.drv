return function()
  local icons = require "nvim-nonicons"

  require("todo-comments").setup {
    keywords = {
      FIX = {
        icon = icons.get "bug",
      },
      TODO = {
        icon = icons.get "tasklist",
      },
      HACK = {
        icon = icons.get "flame",
      },
      WARN = {
        icon = icons.get "alert",
      },
      PERF = {
        icon = icons.get "stopwatch",
      },
      NOTE = {
        -- HACK: No trailing "." for the alternate to make the highlighting visually consistent
        alt = { "N.B" },
        icon = icons.get "comment",
      },
    },
    highlight = {
      pattern = [[.*<(KEYWORDS)[.:]{1}]],
    },
    search = {
      pattern = [[\b(KEYWORDS)[.:]{1}]],
    },
    signs = true,
  }

  local hi = require("flavours").highlight
  local palette = require "flavours.palette"

  hi.TodoBgTODO = { bg = palette.base0A, fg = palette.base00, bold = true }
  hi.TodoFgTODO = { fg = palette.base0A }
  hi.TodoSignTODO = { fg = palette.baseOA }
  hi.TodoBgFIX = { bg = palette.base08, fg = palette.base00, bold = true }
  hi.TodoFgFIX = { fg = palette.base08 }
  hi.TodoSignFIX = { fg = palette.base08 }
  hi.TodoBgWARN = { bg = palette.base09, fg = palette.base00, bold = true }
  hi.TodoFgWARN = { fg = palette.base09 }
  hi.TodoSignWARN = { fg = palette.base09 }
  hi.TodoBgHACK = { bg = palette.base08, fg = palette.base00, bold = true }
  hi.TodoFgHACK = { fg = palette.base08 }
  hi.TodoSignHACK = { fg = palette.base08 }
  hi.TodoBgPERF = { bg = palette.base0B, fg = palette.base00, bold = true }
  hi.TodoFgPERF = { fg = palette.base0B }
  hi.TodoSignPERF = { fg = palette.base0B }
  hi.TodoBgNOTE = { bg = palette.base0D, fg = palette.base00, bold = true }
  hi.TodoFgNOTE = { fg = palette.base0D }
  hi.TodoSignNOTE = { fg = palette.base0D }
end
