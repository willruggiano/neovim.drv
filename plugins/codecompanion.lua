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

  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", { clear = true })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local handle = create_progress_handle(request)
      store_progress_handle(request.data.id, handle)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local handle = pop_progress_handle(request.data.id)
      if handle then
        handle:finish()
      end
    end,
  })

  --[[
  --    codecompanion.nvim
  --]]

  local strategy = (function()
    if vim.fn.executable "ollama" == 1 then
      return {
        adapter = "ollama",
        model = vim.env.CODECOMPANION_MODEL or "devstral:latest",
      }
    else
      return {
        adapter = "openai",
      }
    end
  end)()

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
      vectorcode = {
        opts = {
          add_tool = true,
          add_slash_command = true,
          tool_opts = {},
        },
      },
    },
    strategies = {
      chat = strategy,
      inline = strategy,
      cmd = strategy,
    },
  }
end
