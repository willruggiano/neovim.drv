-- TODO: Break this out into separate files per lsp
return function()
  local lsp = require "bombadil.lsp"

  --
  -- Styling
  --

  lsp.kind.init {
    symbol_map = {
      Copilot = "",
    },
  }

  ---@diagnostic disable-next-line: missing-parameter
  for type, icon in pairs(lsp.signs.get()) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  --
  -- Diagnostics
  --

  vim.diagnostic.config {
    float = {
      border = "single",
    },
    severity_sort = true,
    signs = false,
    underline = true,
    update_in_insert = false,
    virtual_text = {
      format = function(diagnostic)
        return string.format("%s  %s", lsp.signs.severity(diagnostic.severity), diagnostic.message)
      end,
      prefix = "",
      spacing = 4,
      suffix = function(diagnostic)
        return diagnostic.source and " [" .. diagnostic.source .. "]" or ""
      end,
    },
  }

  --
  -- Generic lsp configuration
  --

  vim.lsp.config("dartls", {
    commands = {
      ["refactor.perform"] = function(command, ctx)
        local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

        local kind = command.arguments[1]
        if kind ~= "EXTRACT_METHOD" and kind ~= "EXTRACT_WIDGET" and kind ~= "EXTRACT_LOCAL_VARIABLE" then
          client:request("workspace/executeCommand", command)
          return
        end

        vim.ui.input({ prompt = kind .. "> " }, function(name)
          if not name then
            return
          end
          -- The 6th argument is the additional options of the refactor command.
          -- For the extract method/local variable/widget commands, we can specify an optional `name` option.
          -- see more: https://github.com/dart-lang/sdk/blob/e995cb5f7cd67d39c1ee4bdbe95c8241db36725f/pkg/analysis_server/lib/src/lsp/handlers/commands/perform_refactor.dart#L53
          command.arguments[6] = { name = name }
          client:request("workspace/executeCommand", command)
        end)
      end,
    },
  })

  vim.lsp.config("efm", {
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
  })

  vim.lsp.config("jsonls", {
    cmd = { "vscode-json-languageserver", "--stdio" },
    settings = {
      json = {
        schemas = require("schemastore").json.schemas {
          extra = {
            {
              description = "Configuration file for relay-compiler",
              fileMatch = { "relay.config.json" },
              name = "relay.config.json",
              url = "node_modules/relay-compiler/relay-compiler-config-schema.json",
            },
          },
        },
        validate = { enable = true },
      },
    },
  })

  vim.lsp.config("lua_ls", {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= "/home/" .. vim.env.USER .. "/dev/neovim.drv" then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            "lua/?.lua",
            "lua/?/init.lua",
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- Depending on the usage, you might want to add additional paths
            -- here.
            -- '${3rd}/luv/library'
            -- '${3rd}/busted/library'
          },
          -- Or pull in all of 'runtimepath'.
          -- NOTE: this is a lot slower and will cause issues when working on
          -- your own configuration.
          -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          -- library = {
          --   vim.api.nvim_get_runtime_file('', true),
          -- }
        },
      })
    end,
    settings = {
      Lua = {},
    },
  })

  vim.lsp.config("nil_ls", {
    settings = {
      ["nil"] = {
        formatting = {
          command = { "alejandra", "-qq" },
        },
      },
    },
  })

  vim.lsp.config("postgres_lsp", {
    capabilities = {
      workspace = {
        didChangeConfiguration = { dynamicRegistration = true },
      },
    },
    cmd = { "postgrestools", "lsp-proxy" },
    filetypes = { "sql" },
    single_file_support = true,
    settings = {
      db = {
        host = vim.env.PGHOST,
        database = vim.env.PGDATABASE,
        username = vim.env.PGUSER,
        password = vim.env.PGPASSWORD,
      },
    },
  })

  vim.lsp.config("vtsls", {
    root_markers = { "tsconfig.json" },
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
      },
    },
  })

  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        schemas = require("schemastore").yaml.schemas(),
        validate = { enable = true },
      },
    },
  })

  vim.lsp.config("zls", {
    settings = {
      zls = {
        -- enable_build_on_save = true, -- default with a check step
        semantic_tokens = "full",
        -- warn_style = true,
      },
    },
  })

  vim.lsp.enable {
    "basedpyright",
    "bashls",
    "biome",
    "clangd",
    "cmake",
    "dartls",
    "efm",
    "elmls",
    "graphql",
    "hls",
    "jsonls",
    "lua_ls",
    "marksman",
    "mdx_analyzer",
    "nginx_language_server",
    "nil_ls",
    "postgres_lsp",
    "prismals",
    -- "relay_lsp",
    "ruff",
    "rust_analyzer",
    -- "sqruff",
    "superhtml",
    "tsp_server",
    "vtsls",
    "yamlls",
    "zls",
  }

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have a valid client")

      if
        client:supports_method "textDocument/hover" or client.name == "dartls" -- FIXME: lmao wat
      then
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover { border = "single", wrap = false }
        end, { buffer = bufnr, desc = "[lsp] hover" })
      end

      if client:supports_method "textDocument/signatureHelp" then
        vim.keymap.set("i", "<C-s>", function()
          vim.lsp.buf.signature_help { border = "single", wrap = false }
        end, { buffer = bufnr, desc = "[lsp] signature help" })
      end

      if
        client:supports_method "textDocument/codeAction" or client.name == "dartls" -- FIXME: lmao wat
      then
        vim.keymap.set(
          "n",
          "<localleader>a",
          require("fastaction").code_action,
          { buffer = bufnr, desc = "[lsp] code action" }
        )
        vim.keymap.set(
          "v",
          "<localleader>a",
          [[<esc><cmd>lua require("fastaction").range_code_action()<cr>]],
          { buffer = bufnr, desc = "[lsp] code action" }
        )
      end

      if client:supports_method "textDocument/declaration" then
        vim.keymap.set("n", "gD", function()
          vim.lsp.buf.declaration { reuse_win = true }
        end, { buffer = bufnr, desc = "[lsp] goto declaration" })
      end

      if client:supports_method "textDocument/documentHighlight" then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved", "CursorMovedI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end

      if client:supports_method "textDocument/typeDefinition" then
        vim.keymap.set("n", "gT", function()
          vim.lsp.buf.type_definition { reuse_win = true }
        end, { buffer = bufnr, desc = "[lsp] typedef" })
      end

      if client:supports_method "workspace/symbol" then
        vim.keymap.set("n", "<space>s", function()
          vim.ui.input({ prompt = "Query> " }, function(query)
            vim.lsp.buf.workspace_symbol(query)
          end)
        end, { buffer = bufnr, desc = "[lsp] workspace symbols" })
      end
    end,
  })

  -- Python overrides.
  -- `import foo`
  --         ^^^ @lsp.type.namespace.python
  vim.api.nvim_set_hl(0, "@lsp.type.namespace.python", { link = "Type", force = true })
end
