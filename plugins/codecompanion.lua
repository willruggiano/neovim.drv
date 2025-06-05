return function()
  --[[
  --    codecompanion.nvim x fidget.nvim,
  --    courtesy of: https://github.com/olimorris/codecompanion.nvim/discussions/813
  --]]

  local progress = require "fidget.progress"

  local llm_role_title = function(adapter)
    local parts = {}
    table.insert(parts, adapter.formatted_name)
    if adapter.model and adapter.model ~= "" then
      table.insert(parts, "(" .. adapter.model .. ")")
    end
    return table.concat(parts, " ")
  end

  local handles = {}

  local create_progress_handle = function(request)
    return progress.handle.create {
      title = " Requesting assistance (" .. request.data.strategy .. ")",
      message = "In progress...",
      lsp_client = {
        name = llm_role_title(request.data.adapter),
      },
    }
  end

  local pop_progress_handle = function(id)
    local handle = handles[id]
    handles[id] = nil
    return handle
  end

  local store_progress_handle = function(id, handle)
    handles[id] = handle
  end

  local report_exit_status = function(handle, request)
    if request.data.status == "success" then
      handle.message = "Completed"
    elseif request.data.status == "error" then
      handle.message = "Error"
    else
      handle.message = "Cancelled"
    end
  end

  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", { clear = true })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      vim.print "request started!"
      local handle = create_progress_handle(request)
      store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local handle = pop_progress_handle(request.data.id)
      vim.print "request finished!"
      if handle then
        vim.print "found a handle"
        report_exit_status(handle, request)
        handle:finish()
      end
    end,
  })

  --[[
  --    codecompanion.nvim
  --]]

  require("codecompanion").setup {
    display = {
      action_palette = {
        provider = "telescope",
      },
    },
    extensions = {
      mcphub = {
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true,
          make_vars = true,
          make_slash_commands = true,
        },
      },
      -- vectorcode = {
      --   opts = {
      --     add_tool = true,
      --     add_slash_command = true,
      --     tool_opts = {},
      --   },
      -- },
    },
    strategies = {
      chat = {
        adapter = "ollama",
        model = "qwen3:30b",
      },
      inline = {
        adapter = "ollama",
        model = "qwen3:30b",
      },
      cmd = {
        adapter = "ollama",
        model = "qwen3:30b",
      },
    },
  }
end
