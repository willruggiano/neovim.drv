return function()
  require("quicker").setup {
    borders = {
      vert = "|",
      strong_header = "-",
      strong_cross = "+",
      strong_end = "|",
      soft_header = "-",
      soft_cross = "+",
      soft_end = "|",
    },
    keys = {
      {
        ">",
        function()
          require("quicker").expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        function()
          require("quicker").collapse()
        end,
        desc = "Collapse quickfix context",
      },
    },
    opts = {
      number = true,
      relativenumber = true,
      signcolumn = "yes",
    },
    type_icons = {
      E = " ",
      W = " ",
      I = " ",
      N = " ",
      H = " ",
    },
  }
end
