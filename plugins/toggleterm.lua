return function()
  require("toggleterm").setup {
    close_on_exit = false,
    direction = "vertical",
    float_opts = {
      border = "single",
    },
    insert_mappings = false,
    open_mapping = [[<C-\>]],
    shade_terminals = false,
    size = function(args)
      if args.direction == "horizontal" then
        return 20
      elseif args.direction == "vertical" then
        return 75
      end
    end,
    terminal_mappings = false,
  }
end
