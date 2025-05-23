return function()
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
      chat = { adapter = "anthropic" },
      inline = { adapter = "anhtropic" },
      cmd = { adapter = "anthropic" },
    },
  }
end
