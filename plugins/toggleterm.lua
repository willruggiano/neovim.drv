return function()
  local toggleterm = require "toggleterm"

  toggleterm.setup {
    float_opts = {
      border = "single",
    },
    shade_terminals = false,
    size = function(args)
      if args.direction == "horizontal" then
        return 20
      elseif args.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap

  nnoremap("<space><space>", function()
    toggleterm.toggle_command("direction=float", vim.v.count)
  end, { desc = "Toggle terminal" })

  nnoremap("<c-space>", function()
    toggleterm.toggle_command("direction=vertical", vim.v.count)
  end, { desc = "Toggle terminal (floating)" })
end
