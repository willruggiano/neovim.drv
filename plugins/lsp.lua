-- TODO: Break this out into separate files per lsp
return function()
  local lsp = require "bombadil.lsp"
  local lspconfig = require "lspconfig"
  local util = require "lspconfig.util"

  --
  -- Styling
  --

  lsp.kind.init {
    symbol_map = {
      Copilot = "",
    },
  }

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
        -- TODO: diagnostic.source?
        return string.format("%s  %s", lsp.signs.severity(diagnostic.severity), diagnostic.message)
      end,
      prefix = "",
      spacing = 4,
      suffix = function(diagnostic)
        return diagnostic.source and " [" .. diagnostic.source .. "]" or ""
      end,
    },
  }

  ---@diagnostic disable-next-line: missing-parameter
  for type, icon in pairs(lsp.signs.get()) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  --
  -- Generic lsp configuration
  --

  local servers = {
    basedpyright = {},
    bashls = {},
    biome = {
      capabilities = {
        textDocument = {
          onTypeFormatting = { dynamicRegistration = true },
        },
      },
    },
    clangd = {
      capabilities = {
        offsetEncoding = { "utf-16" },
      },
    },
    cmake = {},
    efm = {
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
    },
    graphql = {},
    -- harper_ls = {},
    hls = {},
    jsonls = {
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
    },
    lua_ls = {
      root_dir = function(fname)
        return util.find_git_ancestor(fname) or util.path.dirname(fname)
      end,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
            keywordSnippet = "Replace",
          },
          format = {
            enable = false,
          },
          runtime = {
            version = "LuaJIT",
            path = { "?.lua", "?/init.lua" },
            pathStrict = true,
          },
          workspace = {
            checkThirdParty = false,
            library = (function()
              local library = {}

              local function add(dir)
                for _, p in
                  ipairs(vim.fn.expand(dir .. "/lua", false, true) --[=[@as string[]]=])
                do
                  table.insert(library, p)
                end
              end

              add "$VIMRUNTIME"

              return library
            end)(),
          },
        },
      },
    },
    marksman = {},
    mdx_analyzer = {},
    nginx_language_server = {},
    nil_ls = {
      settings = {
        ["nil"] = {
          formatting = {
            command = { "alejandra", "-qq" },
          },
        },
      },
    },
    postgres_lsp = {
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
    },
    prismals = {
      capabilities = {
        workspace = {
          didChangeConfiguration = { dynamicRegistration = true },
        },
      },
    },
    relay_lsp = {
      -- auto_start_compiler = true,
      root_dir = util.root_pattern "relay.config.*",
    },
    ruff = {},
    rust_analyzer = {},
    -- sqruff = {
    --   capabilities = {
    --     textDocument = {
    --       didSave = { dynamicRegistration = true },
    --     },
    --   },
    -- },
    -- tailwindcss = {
    --   root_dir = util.root_pattern "tailwind.config.*",
    -- },
    tsp_server = {
      root_markers = { "tspconfig.yaml" },
    },
    vtsls = {
      root_dir = util.root_pattern ".git",
      settings = {
        vtsls = {
          autoUseWorkspaceTsdk = true,
        },
      },
    },
    yamlls = {
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
          validate = { enable = true },
        },
      },
    },
    zls = {
      settings = {
        zls = {
          -- enable_build_on_save = true, -- default with a check step
          semantic_tokens = "full",
          -- warn_style = true,
        },
      },
    },
  }

  for name, config in pairs(servers) do
    config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
    -- Doesn't seem like we're quite ready for this.
    -- @see https://github.com/neovim/nvim-lspconfig/issues/3705
    -- if vim.tbl_contains({ "mdx_analyzer", "relay_lsp" }, name) then
    lspconfig[name].setup(config)
    -- else
    --   vim.lsp.config(name, config)
    -- end
    -- vim.lsp.enable(name)
  end

  if pcall(require, "tailwind-tools") then
    require("tailwind-tools").setup {
      document_color = {
        kind = "foreground",
      },
      keymaps = {
        smart_increment = {
          enabled = false,
        },
      },
    }
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have a valid client")

      if client:supports_method "textDocument/hover" then
        vim.keymap.set("n", "K", function()
          vim.lsp.buf.hover { border = "single" }
        end, { buffer = bufnr, desc = "[lsp] hover" })
      end

      if client:supports_method "textDocument/signatureHelp" then
        vim.keymap.set("i", "<C-s>", function()
          vim.lsp.buf.signature_help { border = "single" }
        end, { buffer = bufnr, desc = "[lsp] signature help" })
      end

      if client:supports_method "textDocument/diagnostic" then
        vim.keymap.set("n", "<localleader>e", function()
          vim.diagnostic.open_float()
        end, { buffer = bufnr, desc = "[lsp] explain" })
      end

      if client:supports_method "textDocument/codeAction" then
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
end
