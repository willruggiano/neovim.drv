local config = {
  filetypes = { "cpp", "nix" },
  settings = {
    languages = {
      cpp = {
        {
          lintSource = "cppcheck",
          lintCommand = [[cppcheck --quiet --enable=warning,style,performance,portability --language=cpp --error-exitcode=1 "${INPUT}"]],
          lintStdin = false,
          lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
          rootMarkers = { "CMakeLists.txt", "compile_commands.json", ".git" },
        },
      },
      nix = {
        {
          lintSource = "statix",
          lintCommand = "statix check --stdin --format=errfmt",
          lintStdin = true,
          lintIgnoreExitCode = true,
          lintFormats = { "<stdin>>%l:%c:%t:%n:%m" },
          rootMarkers = { "flake.nix", "shell.nix", "default.nix" },
        },
      },
    },
  },
} --[[@type vim.lsp.Config]]

return config
