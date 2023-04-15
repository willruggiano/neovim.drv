return function()
  local extensions = {}

  extensions.firvish = {
    filetypes = { "firvish" },
    sections = {
      lualine_a = { "mode" },
      lualine_c = {
        {
          "filename",
          path = 2,
        },
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_c = {
        {
          "filename",
          path = 2,
        },
      },
      lualine_x = { "location" },
    },
  }

  extensions.lir = {
    filetypes = { "lir" },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        function()
          return require("lir.vim").get_context().dir
        end,
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_c = {
        function()
          return require("lir.vim").get_context().dir
        end,
      },
      lualine_x = { "location" },
    },
  }

  local palette = require "flavours.palette"
  local theme = {
    normal = {
      a = { fg = palette.base01, bg = palette.base0D },
      b = { fg = palette.base05, bg = palette.base02 },
      c = { fg = palette.base04, bg = palette.base01 },
    },
    replace = {
      a = { fg = palette.base01, bg = palette.base09 },
      b = { fg = palette.base05, bg = palette.base02 },
    },
    insert = {
      a = { fg = palette.base01, bg = palette.base0B },
      b = { fg = palette.base05, bg = palette.base02 },
    },
    visual = {
      a = { fg = palette.base01, bg = palette.base0E },
      b = { fg = palette.base05, bg = palette.base02 },
    },
    inactive = {
      a = { fg = palette.base03, bg = palette.base01 },
      b = { fg = palette.base03, bg = palette.base01 },
      c = { fg = palette.base03, bg = palette.base01 },
    },
  }

  theme.command = theme.normal
  theme.terminal = theme.insert

  require("lualine").setup {
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = theme,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = { "filename" },
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {
      "quickfix",
      "toggleterm",
      extensions.firvish,
      extensions.lir,
    },
  }
end
