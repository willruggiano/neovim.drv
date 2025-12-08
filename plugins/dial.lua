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
    sql = vim.list_extend(default, {
      augend.constant.new {
        elements = { "COMMIT", "ROLLBACK" },
        word = true,
        cyclic = true,
        preserve_case = true,
      },
    }),
  }

  local nnoremap = function(lhs, rhs, opts)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("keep", opts or {}, { noremap = true }))
  end
  local vnoremap = function(lhs, rhs, opts)
    vim.keymap.set("v", lhs, rhs, vim.tbl_extend("keep", opts or {}, { noremap = true }))
  end

  nnoremap("<C-a>", require("dial.map").inc_normal(), { desc = "dial.increment()" })
  nnoremap("<C-x>", require("dial.map").dec_normal(), { desc = "dial.decrement()" })
  vnoremap("<C-a>", require("dial.map").inc_visual(), { desc = "dial.increment()" })
  vnoremap("<C-x>", require("dial.map").dec_visual(), { desc = "dial.decrement()" })
  vnoremap("g<C-a>", require("dial.map").inc_gvisual(), { desc = "dial.increment()" })
  vnoremap("g<C-x>", require("dial.map").dec_gvisual(), { desc = "dial.decrement()" })
end
