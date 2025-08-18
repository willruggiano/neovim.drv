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
      inherit dot-nvim;
      doom-one.package = buildVimPlugin {
        name = "doom-one";
        src = sources."doom-one.nvim";
      };
      treesitter = {
        dependencies = {
          # NOTE: these are the queries from the 'main' branch
          queries.package = pkgs.stdenv.mkDerivation {
            name = "nvim-treesitter-queries";
            src = sources.nvim-treesitter;
            installPhase = ''
              mkdir $out
              mv runtime/queries $out
            '';
            dontBuild = true;
            dontFixup = true;
          };
        };
        package = pkgs.symlinkJoin {
          name = "treesitter";
          paths = with pkgs.vimPlugins.nvim-treesitter-parsers; [
            bash
            c
            cmake
            cpp
            css
            dockerfile
            elm
            fish
            go
            graphql
            haskell
            hcl
            html
            http
            hyprlang
            java
            javascript
            json
            json5
            jsonc
            just
            ledger
            lua
            make
            pkgs.vimPlugins.nvim-treesitter-parsers.markdown
            markdown_inline
            nix
            python
            query
            regex
            rust
            scheme
            sql
            toml
            tsx
            typescript
            vim
            vimdoc
            yaml
            zig
          ];
        };
      };
      # halfspace.package = buildVimPlugin {
      #   name = "halfspace";
      #   src = sources."halfspace.nvim";
      # };
      # mellifluous.package = buildVimPlugin {
      #   name = "mellifluous";
      #   src = sources."mellifluous.nvim";
      # };
      # polychrome.package = buildVimPlugin {
      #   name = "polychrome";
      #   src = sources."polychrome.nvim";
      # };
      # sunburn.package = buildVimPlugin {
      #   name = "sunburn";
      #   src = sources."sunburn.nvim";
      #   dependencies = [polychrome.package];
      #   nvimRequireCheck = "sunburn";
      # };
      # zenbones = {
      #   package = buildVimPlugin {
      #     name = "zenbones";
      #     src = sources."zenbones.nvim";
      #     dependencies = [zenbones.dependencies.lush.package];
      #     nvimRequireCheck = "zenbones";
      #   };
      #   dependencies.lush.package = buildVimPlugin {
      #     name = "lush";
      #     src = sources."lush.nvim";
      #   };
      # };
    };
    paths = with pkgs; [aider-chat-with-help claude-code darkman];
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
        ghost_text.enabled = false;
      };
      fuzzy.prebuilt_binaries.download = false;
      keymap = {
        preset = "default";
        "<C-b>" = false;
        "<C-f>" = false;
        "<C-u>" = ["scroll_documentation_up" "fallback"];
        "<C-d>" = ["scroll_documentation_down" "fallback"];
      };
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

  codecompanion = {
    package = buildVimPlugin {
      name = "codecompanion.nvim";
      src = sources."codecompanion.nvim";
      nvimRequireCheck = "codecompanion";
    };
    config = ./codecompanion.lua;
    dependencies = {
      inherit fidget plenary telescope;
      mcphub = {
        config = true;
        # config.config = ./mcphub-servers.json;
        package = inputs'.mcp-hub-nvim.packages.default;
        paths = with pkgs; [inputs'.mcp-hub.packages.default curl uv];
      };
      # render-markdown = {
      #   src = sources."render-markdown.nvim";
      #   ft = ["markdown" "codecompanion"];
      # };
      # vectorcode = {
      #   config = {
      #     async_backend = "lsp";
      #   };
      #   package = pkgs.vimPlugins.vectorcode-nvim;
      #   paths = [pkgs.vectorcode];
      # };
    };
  };

  colorizer = {
    src = sources."nvim-colorizer.lua";
    config = true;
  };

  # Comment = {
  #   src = sources."Comment.nvim";
  #   config = ./comment.lua;
  #   dependencies = {
  #     inherit nvim-ts-context-commentstring;
  #   };
  # };

  conform = {
    src = sources."conform.nvim";
    config = ./conform.lua;
    paths = with pkgs; [
      jq
      kulala-fmt
      prettier
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
          debugger_cmd = ["js-debug"];
        };
        paths = [pkgs.vscode-js-debug];
      };
    };
    paths = with pkgs.haskellPackages; [
      haskell-debug-adapter
    ];
  };

  # darkman = {
  #   package = config.packages.darkman-nvim;
  #   config = {
  #     change_background = true;
  #     colorscheme = {
  #       dark = "flavours";
  #       light = "flavours";
  #     };
  #   };
  # };

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
      dependencies = [lfs.package];
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
    config.progress.ignore = ["null-ls"];
  };

  flatten = {
    src = sources."flatten.nvim";
    config.window.open = "alternate";
    lazy = false;
    priority = 1001;
  };

  fugitive.src = sources.vim-fugitive;
  fun.package = config.packages.luafun;

  gitsigns = {
    package = buildVimPlugin {
      name = "gitsigns.nvim";
      src = sources."gitsigns.nvim";
      nvimRequireCheck = "gitsigns";
      dependencies = [plenary.package];
    };
    config = ./gitsigns.lua;
  };

  grug-far = {
    src = sources."grug-far.nvim";
    config = ./grug.lua;
    paths = with pkgs; [ast-grep ripgrep];
  };

  hunk = {
    package = buildVimPlugin {
      name = "hunk.nvim";
      src = sources."hunk.nvim";
      dependencies = [nui.package];
    };
    config = ./hunk.lua;
    dependencies = {inherit nui;};
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

  # kulala = {
  #   package = pkgs.vimPlugins.kulala-nvim;
  #   config = {
  #     global_keymaps = true;
  #   };
  # };

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

  leetcode = {
    package = buildVimPlugin {
      name = "leetcode.nvim";
      src = sources."leetcode.nvim";
      doCheck = false;
    };
    dependencies = {inherit telescope plenary nui;};
    config = {
      lang = "typescript";
      picker.provider = "telescope";
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
  };

  lspconfig = {
    package = buildVimPlugin {
      name = "lspconfig";
      src = sources.nvim-lspconfig;
    };
    config = ./lsp.lua;
    dependencies = {
      inherit blink-cmp conform fastaction fun lsp-file-operations lspkind tailwind-tools;
      clangd_extensions.src = sources."clangd_extensions.nvim";
      # flutter-tools.package = pkgs.vimPlugins.flutter-tools-nvim;
      schemastore.src = sources."SchemaStore.nvim";
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
      inotify-tools
      # c
      clang-tools
      cmake-language-server
      cppcheck
      # elm?
      elmPackages.elm-language-server
      # github actions
      actionlint
      # haskell
      haskellPackages.cabal-fmt
      haskellPackages.haskell-language-server
      haskellPackages.ormolu
      # html
      superhtml
      # json
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      # lua
      emmylua-ls
      # sumneko-lua-language-server
      # markdown
      marksman
      # nginx
      nginx-language-server
      # nix
      alejandra
      nil
      statix
      # python
      basedpyright
      ruff
      # rust
      rust-analyzer
      # shell
      nodePackages.bash-language-server
      shellcheck
      shfmt
      # sql
      postgres-lsp
      squawk
      # sqruff
      # zig
      zls
      # other
      efm-langserver
      harper
      # typespec # broken
    ];
  };

  lspkind = {
    src = sources."lspkind.nvim";
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

  matchup.package = buildVimPlugin {
    name = "matchup";
    src = sources.vim-matchup;
    nvimRequireCheck = "match-up";
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

  split = {
    src = sources."split.nvim";
    config = true; # maps: gs, gS
  };

  sqlite = {
    package = buildVimPlugin {
      name = "sqlite.lua";
      src = sources."sqlite.lua";
      nvimRequireCheck = "sqlite";
    };
    cpath = "${pkgs.sqlite.out}/lib/?.so";
    init = ./sqlite.lua;
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
      telescope-live-grep-args = {
        package = buildVimPlugin {
          name = "telescope-live-grep-args";
          src = sources."telescope-live-grep-args.nvim";
          paths = with pkgs; [ripgrep];
          doCheck = false;
          doInstallCheck = true;
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
    config = ./toggleterm.lua;
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
