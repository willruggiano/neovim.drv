return function()
  require("codecompanion").setup {
    display = {
      action_palette = {
        provider = "telescope",
      },
    },
    extensions = {
      vectorcode = {
        opts = {
          add_tool = true,
          add_slash_command = true,
          tool_opts = {},
        },
      },
    },
    strategies = {
      chat = {
        adapter = "anthropic",
        tools = {
          mcp = {
            -- calling it in a function would prevent mcphub from being loaded before it's needed
            callback = function()
              return require "mcphub.extensions.codecompanion"
            end,
            description = "Call tools and resources from MCP servers",
          },
        },
      },
      inline = { adapter = "anhtropic" },
      cmd = { adapter = "anthropic" },
    },
  }
end
