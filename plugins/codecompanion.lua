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

  local group = vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true })

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local handle = create_progress_handle(request)
      store_progress_handle(request.data.id, handle)
    end,
  })

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd("User", {
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

  local strategy = {
    adapter = {
      name = "gemini",
      model = "gemini-2.5-pro",
    },
  }

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
          -- MCP Tools
          make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
          show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
          add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
          show_result_in_chat = true, -- Show tool results directly in chat buffer
          format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
          -- MCP Resources
          make_vars = true, -- Convert MCP resources to #variables for prompts
          -- MCP Prompts
          make_slash_commands = true, -- Add MCP prompts as /slash commands
        },
      },
      -- vectorcode = {},
    },
    strategies = {
      chat = strategy,
      inline = strategy,
      cmd = strategy,
    },
  }

  vim.keymap.set("n", "<space>a", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion" })
  vim.keymap.set("v", "<space>a", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion (inline)" })

  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionChatOpened",
    group = group,
    callback = function(request)
      vim.treesitter.start(request.buf)
    end,
  })
end
