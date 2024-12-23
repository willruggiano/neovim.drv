return function()
  require("toggleterm").setup {
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
end
