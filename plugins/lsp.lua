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

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

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

  local function on_init(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
  end

  local keymap = require "bombadil.lib.keymap"

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local function on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    keymap.nnoremaps {
      -- TODO: Could we combine code actions and lenses?
      ["<localleader>ca"] = {
        vim.lsp.buf.code_action,
        { buffer = bufnr, desc = "Code actions" },
      },
      ["<localleader>cl"] = {
        vim.lsp.codelens.run,
        { buffer = bufnr, desc = "Code lens" },
      },
      ["<localleader>d"] = {
        function()
          require("telescope.builtin").diagnostics { bufnr = bufnr }
        end,
        { buffer = bufnr, desc = "Diagnostics" },
      },
      ["<localleader>f"] = {
        function()
          require("conform").format {
            async = true,
            bufnr = bufnr,
            lsp_fallback = true,
          }
        end,
        { buffer = bufnr, desc = "Format" },
      },
      ["<localleader><localleader>d"] = {
        vim.diagnostic.open_float,
        { buffer = bufnr, desc = "Line diagnostics" },
      },
      ["<localleader><localleader>w"] = {
        function()
          vim.diagnostic.setqflist { open = false }
          vim.cmd.copen { mods = { split = "botright" } }
        end,
        { buffer = bufnr, desc = "Workspace diagnostics" },
      },
      ["<localleader>rn"] = {
        vim.lsp.buf.rename,
        { buffer = bufnr, desc = "Rename" },
      },
      ["<localleader>rr"] = {
        function()
          vim.lsp.stop_client(vim.lsp.get_clients { bufnr = bufnr }, true)
          vim.cmd.edit()
        end,
        { buffer = bufnr, desc = "Restart lsp clients" },
      },
      ["<space>s"] = {
        require("telescope.builtin").lsp_document_symbols,
        { buffer = bufnr, desc = "Symbols" },
      },
      ["<space>w"] = {
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        { buffer = bufnr, desc = "Workspace symbols" },
      },
      gd = {
        function()
          vim.lsp.buf.definition {
            reuse_win = true,
          }
        end,
        { buffer = bufnr, desc = "Definition" },
      },
      gi = {
        vim.lsp.buf.implementation,
        { buffer = bufnr, desc = "Implementation" },
      },
      gr = {
        vim.lsp.buf.references,
        { buffer = bufnr, desc = "References" },
      },
      gD = {
        function()
          vim.lsp.buf.declaration {
            reuse_win = true,
          }
        end,
        { buffer = bufnr, desc = "Declaration" },
      },
      gT = {
        function()
          vim.lsp.buf.type_definition {
            reuse_win = true,
          }
        end,
        { buffer = bufnr, desc = "Type definition" },
      },
      K = {
        vim.lsp.buf.hover,
        { buffer = bufnr, desc = "Hover" },
      },
    }

    keymap.vnoremaps {
      ["<localleader>ca"] = {
        vim.lsp.buf.code_action,
        { buffer = bufnr, desc = "Code actions" },
      },
      ["<localleader>f"] = {
        function()
          require("conform").format {
            async = true,
            bufnr = bufnr,
            lsp_fallback = true,
          }
        end,
        { buffer = bufnr, desc = "Format" },
      },
    }

    if client.supports_method "textDocument/documentHighlight" then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "BufLeave", "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client.supports_method "textDocument/codeLens" then
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.refresh { bufnr = bufnr }
        end,
      })
    end
  end

  local updated_capabilities = require("cmp_nvim_lsp").default_capabilities()

  updated_capabilities.textDocument.codeLens = {
    dynamicRegistration = true,
  }
  updated_capabilities.textDocument.completion.completionItem.snippetSupport = true
  updated_capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  updated_capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  local server_overrides = {
    clangd = {
      capabilities = {
        offsetEncoding = { "utf-16" },
      },
    },
    efm = {
      filetypes = { "cpp", "nix", "yaml" },
      settings = {
        languages = {
          cpp = {
            {
              prefix = "cppcheck",
              lintSource = "cppcheck",
              lintCommand = [[cppcheck --quiet --enable=warning,style,performance,portability --language=cpp --error-exitcode=1 "${INPUT}"]],
              lintStdin = false,
              lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
              rootMarkers = { "CMakeLists.txt", "compile_commands.json", ".git" },
            },
          },
          nix = {
            {
              prefix = "statix",
              lintSource = "statix",
              lintCommand = "statix check --stdin --format=errfmt",
              lintStdin = true,
              lintIgnoreExitCode = true,
              lintFormats = { "<stdin>>%l:%c:%t:%n:%m" },
              rootMarkers = { "flake.nix", "shell.nix", "default.nix" },
            },
          },
          yaml = {
            {
              prefix = "actionlint",
              lintSource = "actionlint",
              lintCommand = [[actionlint -no-color -oneline -stdin-filename "${INPUT}" -]],
              lintStdin = true,
              lintFormats = {
                "%f:%l:%c: %.%#: SC%n:%trror:%m",
                "%f:%l:%c: %.%#: SC%n:%tarning:%m",
                "%f:%l:%c: %.%#: SC%n:%tnfo:%m",
                "%f:%l:%c: %m",
              },
              requireMarker = true,
              rootMarkers = { ".github/" },
            },
          },
        },
      },
    },
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
                url = "https://raw.githubusercontent.com/facebook/relay/main/compiler/crates/relay-compiler/relay-compiler-config-schema.json",
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
    nil_ls = {
      settings = {
        ["nil"] = {
          formatting = {
            command = { "alejandra", "-qq" },
          },
        },
      },
    },
    relay_lsp = {
      root_dir = util.root_pattern "relay.config.*",
    },
    tailwindcss = {
      root_dir = util.root_pattern "tailwind.config.*",
    },
    yamlls = {
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
          validate = { enable = true },
        },
      },
    },
  }

  local servers = {
    "bashls",
    "biome",
    "clangd",
    "cmake",
    "efm",
    "graphql",
    "hls",
    "jsonls",
    "lua_ls",
    "marksman",
    "nil_ls",
    "prismals",
    "basedpyright",
    "relay_lsp",
    "ruff_lsp",
    "sqruff",
    -- "tailwindcss",
    -- "ts_ls",
    "yamlls",
    "zls",
  }
  for _, name in ipairs(servers) do
    lspconfig[name].setup(vim.tbl_deep_extend("force", {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = updated_capabilities,
    }, server_overrides[name] or {}))
  end

  if os.getenv "ENABLE_POSTGRES_LSP" then
    lspconfig.postgres_lsp.setup {
      cmd = { "./target/debug/postgres_lsp" },
      on_init = on_init,
      on_attach = on_attach,
      capabilities = updated_capabilities,
      root_dir = function()
        return vim.fn.getcwd()
      end,
    }
  end

  if not pcall(require, "rust-tools") then
    lspconfig.rust_analyzer.setup {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = updated_capabilities,
      settings = {
        ["rust-analyzer"] = {
          assist = {
            importGranularity = "module",
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
          },
          procMacro = {
            enable = true,
          },
        },
      },
    }
  else
    local rt = require "rust-tools"
    rt.setup {
      server = {
        -- on_init = on_init,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          keymap.nnoremap("K", rt.hover_actions.hover_actions, { buffer = bufnr, desc = "Hover actions" })
          vim.api.nvim_set_option_value("errorformat", " --> %f:%l:%c", { buf = bufnr })
        end,
      },
      tools = {
        executor = require("rust-tools.executors").quickfix,
        hover_actions = {
          border = "single",
        },
      },
    }
  end

  if pcall(require, "tailwind-tools") then
    require("tailwind-tools").setup {
      server = {
        on_attach = on_attach,
      },
      document_color = {
        kind = "foreground",
      },
    }
  else
    lspconfig.tailwindcss.setup {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = updated_capabilities,
    }
  end

  if pcall(require, "vtsls") then
    require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    lspconfig.vtsls.setup {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = updated_capabilities,
    }
  elseif pcall(require, "typescript-tools") then
    require("typescript-tools").setup {
      on_attach = on_attach,
      settings = {
        expose_as_code_action = "all",
      },
    }
  else
    lspconfig.ts_ls.setup {
      on_init = on_init,
      on_attach = on_attach,
      capabilities = updated_capabilities,
    }
  end
end
