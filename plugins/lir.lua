return function()
  local icons = require "nvim-nonicons"
  local devicons = require "nvim-web-devicons"

  devicons.set_icon {
    lir_folder_icon = {
      icon = icons.get "file-directory",
      color = "#7ebae4",
      name = "LirFolderNode",
    },
  }

  local lir = require "lir"
  local actions = require "lir.actions"
  local clipboard_actions = require "lir.clipboard.actions"
  local mark_actions = require "lir.mark.actions"
  local lir_utils = require "lir.utils"
  local Path = require "plenary.path"
  local f = require "bombadil.lib.functional"
  local buffers = require "bombadil.lib.buffers"

  local get_context = function(absolute)
    local ctx = require("lir.vim").get_context()
    local fname = ctx:current_value()
    if absolute then
      return ctx, ctx.dir .. fname
    else
      return ctx, fname
    end
  end

  local custom_actions = {}

  custom_actions.new = function()
    local ctx, _ = get_context()

    local name = vim.fn.input(ctx.dir)
    if name == "" then
      return
    end

    local path = Path:new(ctx.dir .. name)
    if path:exists() then
      lir_utils.error "Pathname already exists"
      local ln = ctx:indexof(name)
      if ln then
        vim.cmd(tostring(ln))
      end
      return
    end

    local pathsep = Path.path.sep
    if name:sub(-#pathsep) == pathsep then
      path:mkdir { parents = true }
    else
      path:touch { parents = true }
    end
    actions.reload()

    vim.schedule(function()
      local ln = require("lir.vim").get_context():indexof(name)
      if ln then
        vim.cmd(tostring(ln))
      end
    end)
  end

  custom_actions.edit = function()
    local _, path = get_context()
    local curbuf = vim.api.nvim_win_get_buf(0)
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      local b = vim.api.nvim_win_get_buf(w)
      if curbuf ~= b then
        vim.api.nvim_win_call(w, function()
          vim.cmd("e " .. path)
        end)
        return
      end
    end
    ---@diagnostic disable-next-line: missing-parameter
    actions.edit()
  end

  local fsize = function(bytes)
    return require("bombadil.lib.bytes").human_readable(bytes)
  end

  local username = function(uid)
    ---@diagnostic disable-next-line: missing-parameter
    return os.capture(string.format("id -un %s", uid))
  end

  local strftime = function(dt)
    -- TODO: posix-long-iso =: greater than six months -> year instead of time
    return os.date("%d %b %H:%M", dt)
  end

  local fname = function(path)
    -- TODO: show link target
    return vim.fn.fnamemodify(path, ":t")
  end

  local fs_stat = function(path)
    local lfs = require "lfs"
    local res = lfs.attributes(path)
    local attrs = {}

    attrs.permissions = res.permissions
    attrs.size = fsize(res.size)
    attrs.user = username(res.uid)
    attrs.mtime = strftime(res.modification)
    attrs.name = fname(path)

    return attrs
  end

  custom_actions.stat = function()
    local _, path = get_context(true)
    local attrs = fs_stat(path)
    print(attrs.permissions .. " " .. attrs.size .. " " .. attrs.user .. " " .. attrs.mtime .. " " .. attrs.name)
  end

  custom_actions.yank_basename = function()
    local _, path = get_context()
    vim.fn.setreg(vim.v.register, path)
    print(path)
  end

  custom_actions.yank_path = function()
    local _, path = get_context(true)
    vim.fn.setreg(vim.v.register, path)
    print(path)
  end

  custom_actions.toggle_mark_down = function()
    ---@diagnostic disable-next-line: missing-parameter
    mark_actions.toggle_mark()
    vim.cmd "normal! j"
  end

  custom_actions.toggle_mark_up = function()
    ---@diagnostic disable-next-line: missing-parameter
    mark_actions.toggle_mark()
    vim.cmd "normal! k"
  end

  custom_actions.clear_marks = function()
    local ctx, _ = get_context()
    for _, i in ipairs(ctx:get_marked_items()) do
      i.marked = false
    end
    actions.reload()
  end

  custom_actions.trash = function()
    local ctx, name = get_context()
    if vim.fn.confirm("Delete?: " .. name, "&Yes\n&No", 1) ~= 1 then
      return
    end
    if os.execute("trash " .. ctx.dir .. name) ~= 0 then
      lir_utils.error "Delete file failed"
    end

    actions.reload()
  end

  -- BUG: This could delete multiple buffers if there are multiple buffers open for the same
  -- filename.
  custom_actions.delete = function()
    local _, path = get_context()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      local bname = vim.fn.bufname(b)
      if bname:sub(-#path) == fname then
        require("bombadil.lib.buffers").delete(b)
      end
    end
    custom_actions.trash()
  end

  local firvish = require "firvish"
  local function git(...)
    firvish.start_job {
      command = "git",
      args = { ... },
      filetype = "log",
      title = "git",
      bopen = false,
    }
  end

  custom_actions.git = {
    add = function()
      local ctx, path = get_context(true)
      local marks = ctx:get_marked_items()
      if #marks > 0 then
        local paths = {}
        f.each(
          function(...)
            return table.insert(paths, ...)
          end,
          f.map(function(i)
            return i.fullpath
          end, ipairs(marks))
        )
        git("add", unpack(paths))
      else
        git("add", path)
      end
      actions.reload()
    end,
    diff = function()
      local ctx, path = get_context(true)
      local marks = ctx:get_marked_items()
      if #marks > 0 then
        local paths = {}
        f.each(
          function(...)
            return table.insert(paths, ...)
          end,
          f.map(function(i)
            return i.fullpath
          end, ipairs(marks))
        )
        vim.cmd("DiffviewOpen -- " .. table.concat(paths, " "))
      else
        vim.cmd("DiffviewOpen -- " .. path)
      end
    end,
    restore = function()
      local ctx, path = get_context(true)
      local marks = ctx:get_marked_items()
      if #marks > 0 then
        local paths = {}
        f.each(
          function(...)
            return table.insert(paths, ...)
          end,
          f.map(function(i)
            return i.fullpath
          end, ipairs(marks))
        )
        git("restore", "--staged", unpack(paths))
      else
        git("restore", "--staged", path)
      end
    end,
  }

  custom_actions.toggle_devicons = function()
    local config = require "lir.config"
    config.values.devicons_enable = not config.values.devicons_enable
    actions.reload()
  end

  lir.setup {
    devicons = { enable = true },
    float = { winblend = 15 },
    hide_cursor = true,
    show_hidden_files = true,

    mappings = {
      ["<cr>"] = actions.edit,
      ["<s-cr>"] = custom_actions.edit,
      ["<c-v>"] = actions.vsplit,
      ["<c-s>"] = actions.split,

      ["<tab>"] = custom_actions.toggle_mark_down,
      ["<s-tab>"] = custom_actions.toggle_mark_up,

      ["-"] = actions.up,

      a = custom_actions.new,
      r = actions.rename,
      y = custom_actions.yank_path,
      Y = custom_actions.yank_basename,

      d = custom_actions.delete,
      c = clipboard_actions.copy,
      x = clipboard_actions.cut,
      p = clipboard_actions.paste,

      ["."] = actions.toggle_show_hidden,
      ["`"] = custom_actions.toggle_devicons,
      K = custom_actions.stat,

      ga = custom_actions.git.add,
      gd = custom_actions.git.diff,
      gr = custom_actions.git.restore,
    },
  }

  require("lir.git_status").setup {
    show_ignored = false,
  }

  local explore = function()
    if buffers.nameless(vim.api.nvim_get_current_buf()) then
      vim.cmd "e ."
    else
      vim.cmd "e %:h"
    end
  end

  require("bombadil.lib.keymap").nnoremap("-", explore, { desc = "Explore" })
end
