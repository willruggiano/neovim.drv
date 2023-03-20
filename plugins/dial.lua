return function()
  local augend = require "dial.augend"

  local default = {
    augend.constant.alias.bool,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%m/%d"],
    augend.date.alias["%H:%M"],
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.integer.alias.octal,
    augend.integer.alias.binary,
    augend.semver.alias.semver,
  }

  require("dial.config").augends:register_group {
    default = default,
    cmake = vim.list_extend(default, {
      augend.constant.new {
        elements = { "ON", "OFF" },
        word = true,
        cyclic = true,
      },
      augend.constant.new {
        elements = { "TRUE", "FALSE" },
        word = true,
        cyclic = true,
      },
    }),
    git = vim.list_extend(default, {
      augend.constant.new {
        elements = { "pick", "edit", "fixup", "reword", "squash", "drop" },
        word = true,
        cyclic = true,
      },
    }),
  }

  local nnoremap = require("bombadil.lib.keymap").nnoremap
  local vnoremap = require("bombadil.lib.keymap").vnoremap

  nnoremap("<C-a>", require("dial.map").inc_normal())
  nnoremap("<C-x>", require("dial.map").dec_normal())
  vnoremap("<C-a>", require("dial.map").inc_visual())
  vnoremap("<C-x>", require("dial.map").dec_visual())
  vnoremap("g<C-a>", require("dial.map").inc_gvisual())
  vnoremap("g<C-x>", require("dial.map").dec_gvisual())
end
