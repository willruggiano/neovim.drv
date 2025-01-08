{
  config,
  inputs',
  pkgs,
  ...
}: let
  sources = import ../nix/sources.nix {};
  inherit (pkgs) luajitPackages;
  inherit (pkgs.vimUtils) buildVimPlugin;
in rec {
  bombadil = {
    src = pkgs.callPackage ./bombadil {inherit (config.neovim) colorscheme;};
    config = ./bombadil.lua;
    lazy = false;
    priority = 1000;
    dependencies = {
      inherit lfs;
    };
  };

  abolish = {
    src = sources.vim-abolish;
  };

  blink-cmp = {
    package = inputs'.blink.packages.default.overrideAttrs {
      nvimRequireCheck = "blink-cmp";
    };
    config = {
      appearance.nerd_font_variant = "mono";
      completion = {
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 300;
        };
        ghost_text.enabled = true;
      };
      fuzzy.prebuilt_binaries.download = false;
      keymap.preset = "default";
      sources.default = ["lsp" "path"];
    };
  };

  bqf = {
    src = sources.nvim-bqf;
    config = true;
  };

  # haven't written c++ in awhile... :sad sigh:
  clang-format = {
    src = sources."clang-format.nvim";
    dependencies = {inherit lyaml;};
    ft = ["c" "cpp"];
  };

  Comment = {
    src = sources."Comment.nvim";
    config = ./comment.lua;
    dependencies = {
      inherit nvim-ts-context-commentstring;
    };
  };

  conform = {
    src = sources."conform.nvim";
    config = ./conform.lua;
    paths = with pkgs; [
      biome
      nodePackages.prettier # for markdown
      shellcheck
      shellharden
      shfmt
      python3.pkgs.sqlfmt
      stylua
    ];
  };

  dap = {
    package = buildVimPlugin {
      name = "dap";
      src = sources.nvim-dap;
    };
    config = ./dap.lua;
    dependencies = {
      inherit rapidjson;
      dapui.package = buildVimPlugin {
        name = "dapui";
        src = sources.nvim-dap-ui;
        doCheck = false;
        doInstallCheck = true;
      };
      nio.package = buildVimPlugin {
        name = "nio";
        src = sources.nvim-nio;
      };
      nvim-dap-virtual-text = {
        package = buildVimPlugin {
          name = "nvim-dap-virtual-text";
          src = sources.nvim-dap-virtual-text;
          doCheck = false;
        };
        config = true;
      };
      nvim-dap-vscode-js = {
        package = buildVimPlugin {
          name = "nvim-dap-vscode-js";
          src = sources.nvim-dap-vscode-js;
          doCheck = false;
        };
        config = {
          adapters = [
            "node-terminal"
            "pwa-chrome"
            "pwa-extensionHost"
            "pwa-msedge"
            "pwa-node"
          ];
          debugger_cmd = [
            "node"
            "${inputs'.vscode-js-debug.packages.latest}/lib/node_modules/vscode-js-debug/dist/src/vsDebugServer.js"
          ];
        };
      };
    };
    paths = with pkgs.haskellPackages; [
      haskell-debug-adapter
    ];
  };

  dbee = {
    package = config.packages.nvim-dbee.overrideAttrs (_: {
      dependencies = [nui.package];
    });
    config = ./dbee.lua;
    paths = [config.packages.nvim-dbee.dbee];
  };

  dial = {
    src = sources."dial.nvim";
    config = ./dial.lua;
  };

  dot-nvim = {
    package = buildVimPlugin {
      name = "dot-nvim";
      src = sources.".nvim.nvim";
      doCheck = false;
    };
    dependencies = {inherit lfs;};
  };

  fastaction = {
    src = sources."fastaction.nvim";
    config = {
      dismiss_keys = ["<esc>" "j" "k"];
      popup.border = "single";
    };
  };

  fidget = {
    src = sources."fidget.nvim";
    config.text.spinner = "dots";
    config.sources = {
      null-ls = {
        ignore = true;
      };
    };
  };

  flatten = {
    src = sources."flatten.nvim";
    config.window.open = "alternate";
    lazy = false;
    priority = 1001;
  };

  fugitive = {
    src = sources.vim-fugitive;
    config = ./fugitive.lua;
  };

  fun = {
    package = config.packages.luafun;
  };

  gitsigns = {
    src = sources."gitsigns.nvim";
    config = ./gitsigns.lua;
  };

  grug-far = {
    src = sources."grug-far.nvim";
    config = ./grug.lua;
    paths = with pkgs; [ast-grep ripgrep];
  };

  ibl = {
    package = buildVimPlugin {
      name = "ibl";
      src = sources."indent-blankline.nvim";
      nvimSkipModule = "ibl.config.types";
    };
    config = ./indent-blankline.lua;
  };

  iron = {
    src = sources."iron.nvim";
    config = ./iron.lua;
    paths = [pkgs.bun];
  };

  kulala = {
    src = sources."kulala.nvim";
    config = ./kulala.lua;
    dependencies = {
      inherit nvim-treesitter;
    };
    paths = [
      config.packages.kulala-fmt
    ];
  };

  leap = {
    src = sources."leap.nvim";
    config = ./leap.lua;
    dependencies = {
      flit = {
        src = sources."flit.nvim";
        config = true;
      };
      vim-repeat.src = sources."vim-repeat";
    };
  };

  lfs = let
    package = luajitPackages.luafilesystem;
  in {
    inherit package;
    cpath = "${package}/lib/lua/5.1/?.so";
  };

  lsp-file-operations = {
    package = buildVimPlugin {
      name = "lsp-file-operations";
      src = sources.nvim-lsp-file-operations;
      doCheck = false;
    };
    config = true;
    dependencies = {
      inherit neo-tree;
    };
  };

  lspconfig = {
    package = buildVimPlugin {
      name = "lspconfig";
      src = sources.nvim-lspconfig;
    };
    config = ./lsp.lua;
    dependencies = {
      inherit blink-cmp conform fastaction fun lsp-file-operations lspkind tailwind-tools;
      clangd_extensions = {
        src = sources."clangd_extensions.nvim";
      };
      rust-tools = {
        package = buildVimPlugin {
          name = "rust-tools";
          src = sources."rust-tools.nvim";
          dependencies = [lspconfig.package];
        };
      };
      schemastore = {
        src = sources."SchemaStore.nvim";
      };
      vtsls = {
        package = buildVimPlugin {
          name = "vtsls";
          src = sources.nvim-vtsls;
          nvimSkipModule = "vtsls.lspconfig";
        };
        paths = [pkgs.vtsls];
      };
    };
    paths = with pkgs;
    with config.packages; [
      actionlint
      alejandra # used by nil for formatting
      basedpyright
      biome
      clang-tools
      cmake-language-server
      cppcheck
      efm-langserver
      harper
      haskellPackages.cabal-fmt
      haskellPackages.haskell-language-server
      haskellPackages.ormolu
      inputs'.nil.packages.default
      inputs'.zls.packages.default
      marksman
      nodePackages.bash-language-server
      nodePackages.graphql-language-service-cli
      nodePackages.typescript-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      ruff-lsp
      rust-analyzer
      tailwindcss-language-server
      sqlfluff
      squawk
      statix
      sumneko-lua-language-server
    ];
  };

  lspkind = {
    src = sources."lspkind.nvim";
  };

  lualine = {
    src = sources."lualine.nvim";
    config = ./lualine.lua;
  };

  lyaml = {
    package = pkgs.neovimUtils.buildNeovimPlugin {
      inherit (luajitPackages.lyaml) pname;
    };
  };

  markdown = {
    src = sources.vim-markdown;
    config = ./markdown.lua;
  };

  matchup = {
    package = buildVimPlugin {
      name = "matchup";
      src = sources.vim-matchup;
      dependencies = [nvim-treesitter.package];
    };
    init = ''
      function()
        vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
      end
    '';
    config = ''
      function()
        require("flavours").highlight.MatchParen = "LspReferenceText"
      end
    '';
  };

  neo-tree = {
    package = buildVimPlugin {
      name = "neo-tree";
      src = sources."neo-tree.nvim";
      dependencies = [plenary.package nui.package];
      nvimRequireCheck = "neo-tree";
    };
    config = ./neo-tree.lua;
    dependencies = {
      inherit nui nvim-web-devicons plenary;
    };
  };

  nui.package = buildVimPlugin {
    name = "nui";
    src = sources."nui.nvim";
  };

  nvim-surround = {
    package = buildVimPlugin {
      name = "nvim-surround";
      src = sources.nvim-surround;
      nvimSkipModule = "nvim-surround.queries";
    };
    config = true;
  };

  nvim-treesitter = {
    package = config.packages.nvim-treesitter;
    config = ./treesitter.lua;
    dependencies = {
      inherit matchup nvim-ts-context-commentstring;
      nvim-treesitter-textobjects = {
        package = buildVimPlugin {
          name = "nvim-treesitter-textobjects";
          src = sources.nvim-treesitter-textobjects;
          dependencies = [nvim-treesitter.package];
        };
      };
    };
  };

  nvim-ts-context-commentstring = {
    src = sources.nvim-ts-context-commentstring;
    config = {
      enable_autocmd = false;
    };
  };

  nvim-web-devicons = {
    package = buildVimPlugin {
      name = "nvim-web-devicons";
      src = sources.nvim-web-devicons;
    };
    config = ./devicons.lua;
    dependencies = {
      nvim-nonicons.package = buildVimPlugin {
        name = "nvim-nonicons";
        src = sources.nvim-nonicons;
        dependencies = [nvim-web-devicons.package];
      };
    };
  };

  overseer = {
    package = buildVimPlugin {
      name = "overseer";
      src = sources."overseer.nvim";
      nvimRequireCheck = "overseer";
    };
    config = ./overseer.lua;
  };

  plenary = {
    package = pkgs.vimPlugins.plenary-nvim.overrideAttrs (_: {
      src = sources."plenary.nvim";
    });
  };

  quicker = {
    src = sources."quicker.nvim";
    config = ./quicker.lua;
  };

  rapidjson = let
    package = luajitPackages.rapidjson;
  in {
    inherit package;
    cpath = "${package}/lib/lua/5.1/?.so";
  };

  sqlite = {
    package = buildVimPlugin {
      name = "sqlite.lua";
      src = sources."sqlite.lua";
      nvimRequireCheck = "sqlite";
    };
    cpath = "${pkgs.sqlite.out}/lib/?.so";
    init = ''
      function()
        vim.g.sqlite_clib_path = package.searchpath("libsqlite3", package.cpath)
      end
    '';
  };

  statuscol = {
    src = sources."statuscol.nvim";
    config = {
      setopt = true;
    };
  };

  tabout = {
    src = sources."tabout.nvim";
    config = ./tabout.lua;
  };

  tailwind-tools = {
    src = sources."tailwind-tools.nvim";
  };

  telescope = {
    config = ./telescope.lua;
    dependencies = {
      inherit nvim-web-devicons;
      telescope-fzf-native = {
        package = buildVimPlugin {
          name = "telescope-fzf-native";
          buildPhase = "make";
          dependencies = [telescope.package];
          src = sources."telescope-fzf-native.nvim";
        };
      };
      telescope-smart-open = {
        package = buildVimPlugin {
          name = "smart-open.nvim";
          src = sources."smart-open.nvim";
          doCheck = false;
          doInstallCheck = true;
        };
        dependencies = {inherit sqlite;};
        paths = with pkgs; [ripgrep];
      };
      telescope-symbols = {
        src = sources."telescope-symbols.nvim";
      };
      telescope-ui-select = {
        src = sources."telescope-ui-select.nvim";
      };
      telescope-undo = {
        package = buildVimPlugin {
          name = "telescope-undo";
          src = sources."telescope-undo.nvim";
          dependencies = [plenary.package telescope.package];
        };
        paths = with pkgs; [delta];
      };
    };
    package = buildVimPlugin {
      name = "telescope";
      src = sources."telescope.nvim";
      dependencies = [plenary.package];
    };
    paths = with pkgs; [fd ripgrep];
  };

  toggleterm = {
    src = sources."toggleterm.nvim";
    config = true;
  };

  twilight = {
    src = sources."twilight.nvim";
    config = true;
  };

  which-key = {
    package = buildVimPlugin {
      name = "which-key";
      src = sources."which-key.nvim";
      nvimSkipModule = "which-key.docs";
    };
    config = {
      icons.rules = false;
      notify = false;
    };
  };

  zen-mode = {
    src = sources."zen-mode.nvim";
    config = {
      plugins = {
        gitsigns.enabled = true;
        twilight.enabled = false;
      };
      window = {
        options = {
          number = false;
          relativenumber = false;
          signcolumn = "yes";
        };
      };
    };
  };
}
