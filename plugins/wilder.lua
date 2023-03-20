return function()
  local wilder = require "wilder"

  wilder.setup {
    modes = { ":", "/", "?" },
    next_key = "<C-n>",
    previous_key = "<C-p>",
    accept_key = "<C-y>",
  }

  wilder.set_option("pipeline", {
    wilder.branch(
      wilder.python_file_finder_pipeline {
        file_command = function(ctx, arg)
          if string.find(arg, ".") then
            return { "fd", "-tf", "-H" }
          else
            return { "fd", "-tf" }
          end
        end,
        dir_command = { "fd", "-td" },
        filters = { "cpsm_filter" },
      },
      wilder.cmdline_pipeline {
        fuzzy = 2, -- N.B. candidates do NOT have to start with the first char
        fuzzy_filter = wilder.lua_fzy_filter(),
      },
      wilder.vim_search_pipeline()
    ),
  })

  wilder.set_option(
    "renderer",
    wilder.popupmenu_renderer {
      highlighter = {
        wilder.lua_fzy_highlighter(),
      },
      left = {
        " ",
        wilder.popupmenu_devicons(),
      },
    }
  )
end
