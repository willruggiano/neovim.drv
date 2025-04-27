return function()
  require("codecompanion").setup {
    adapters = {
      opts = { show_defaults = false },
      --
      codellama = function()
        return require("codecompanion.adapters").extend("ollama", {
          name = "codellama",
          schema = {
            model = {
              default = "codellama",
            },
          },
        })
      end,
      ["codellama:code"] = function()
        return require("codecompanion.adapters").extend("ollama", {
          name = "codellama:code",
          schema = {
            model = {
              default = "codellama:code",
            },
          },
        })
      end,
    },
    display = {
      action_palette = {
        provider = "Telescope",
      },
    },
    strategies = {
      chat = {
        adapter = "codellama",
        tools = {
          mcp = {
            callback = function()
              return require "mcphub.extensions.codecompanion"
            end,
            description = "Call tools and resources from MCP servers",
          },
        },
      },
      cmd = {
        adapter = "codellama",
      },
      inline = {
        adapter = "codellama",
      },
    },
  }
end
