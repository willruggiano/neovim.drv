local h = require "null-ls.helpers"
local methods = require "null-ls.methods"
local HOVER = methods.internal.HOVER

local Job = require "plenary.job"

local sources = {}

sources.hover = h.make_builtin {
  name = "man",
  method = HOVER,
  filetypes = { "bash", "sh", "zsh" },
  generator = {
    fn = function(_, done)
      local cword = vim.fn.expand "<cword>"
      local job = Job:new {
        command = "man",
        args = { cword },
        on_exit = function(j, return_val)
          if return_val ~= 0 then
            done(false)
          else
            done(j:result())
          end
        end,
      }

      job:sync()
    end,
    async = true,
  },
}

return sources
