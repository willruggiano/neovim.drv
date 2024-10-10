return function()
  local o = require "overseer"

  ---@diagnostic disable-next-line: missing-fields
  o.setup {
    component_aliases = {
      default = {
        { "display_duration", detail_level = 2 },
        "on_exit_set_status",
        { "on_complete_notify", system = "unfocused" },
      },
      default_vscode = {
        "default",
        { "on_result_diagnostics_quickfix", open = true },
      },
    },
  }

  o.register_template {
    name = "build project",
    builder = function()
      local project = vim.fs.find("tsconfig.json", {
        path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
        stop = vim.loop.cwd(),
        type = "file",
        upward = true,
      })[1]

      return {
        cmd = { "tsc" },
        args = { "-p", project },
        components = {
          "on_exit_set_status",
          { "on_output_parse", problem_matcher = "$tsc" },
          { "on_result_diagnostics_quickfix", open = true },
        },
        strategy = {
          "toggleterm",
          open_on_start = false,
        },
      }
    end,
    condition = {
      filetype = { "typescript" },
      callback = function()
        return #vim.fs.find("tsconfig.json", {
          path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
          stop = vim.loop.cwd(),
          type = "file",
          upward = true,
        }) > 0
      end,
    },
    tags = { o.TAG.BUILD },
  }

  local function register_bun_template(name, args, opts)
    o.register_template(vim.tbl_deep_extend("force", {
      name = name,
      builder = function()
        local file = vim.fn.expand "%"
        return {
          cmd = { "bun" },
          args = { unpack(args), file },
          components = {
            { "display_duration", detail_level = 2 },
            "on_exit_set_status",
          },
          strategy = {
            "toggleterm",
            open_on_start = true,
            direction = "horizontal",
            on_create = function()
              vim.cmd.stopinsert()
            end,
          },
        }
      end,
      condition = {
        filetype = { "typescript" },
      },
      tags = { o.TAG.RUN },
    }, opts or {}))
  end

  register_bun_template("bun run", {})
  register_bun_template("bun test", { "test" }, {
    condition = {
      callback = function()
        local file = vim.fn.expand "%"
        return vim.endswith(file, ".test.ts")
      end,
    },
    priority = 10,
    tags = { o.TAG.TEST },
  })
  register_bun_template("bun test --update-snapshots", { "test", "--update-snapshots" }, {
    condition = {
      callback = function()
        local file = vim.fn.expand "%"
        return vim.endswith(file, ".test.ts")
      end,
    },
    priority = 11,
    tags = { o.TAG.TEST },
  })
  register_bun_template("bun test --only", { "test", "--only" }, {
    condition = {
      callback = function()
        local file = vim.fn.expand "%"
        return vim.endswith(file, ".test.ts")
      end,
    },
    priority = 12,
    tags = { o.TAG.TEST },
  })

  local nnoremaps = require("bombadil.lib.keymap").nnoremaps

  nnoremaps {
    ["<space><cr>"] = {
      function()
        local tasks = o.list_tasks { recent_first = true }
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          o.run_action(tasks[1], "restart")
        end
      end,
      { desc = "RunLast" },
    },
    ["<space>r"] = {
      "<cmd>OverseerRun<cr>",
      { desc = "Run" },
    },
    ["<space>t"] = {
      "<cmd>OverseerToggle bottom<cr>",
      { desc = "Tasks" },
    },
  }
end
