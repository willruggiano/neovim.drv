{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.vimUtils) buildVimPlugin;
in rec {
  bombadil = {
    src = pkgs.callPackage ./bombadil {};
    config = ./bombadil.lua;
    lazy = false;
    priority = 1000;
    dependencies = {
      inherit toggleterm;
      doom-one.package = buildVimPlugin {
        name = "doom-one";
        src = inputs.doom-one;
      };
      clangd_extensions.src = inputs.clangd-ext;
      lsp-file-operations = {
        package = buildVimPlugin {
          name = "lsp-file-operations";
          src = inputs.nvim-lsp-file-ops;
          doCheck = false;
        };
        config = true;
      };
      lspkind = {
        src = inputs.lspkind;
      };
      schemastore.src = inputs.schemastore;
      treesitter = {
        config = ./treesitter.lua;
        dependencies = {
          # NOTE: these are the queries from the 'main' branch
          queries.package = pkgs.stdenv.mkDerivation {
            name = "nvim-treesitter-queries";
            src = inputs.nvim-treesitter;
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
            # n.b. the commented out parsers are vendored by neovim
            bash
            # c
            cmake
            cpp
            css
            cue
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
            # jsonc
            just
            ledger
            # lua
            make
            # markdown
            # markdown_inline
            nix
            python
            # query
            regex
            rust
            scheme
            sql
            toml
            tsx
            typescript
            # vim
            # vimdoc
            yaml
            zig
          ];
        };
      };
    };
    paths = with pkgs; [
      # aider-chat-with-help
      darkman
      inotify-tools
      # c
      clang-tools
      # cmake-language-server
      cppcheck
      # cue
      cue
      # elm
      elmPackages.elm-language-server
      # github actions
      actionlint
      # go
      gopls
      # graphql
      graphql-language-service-cli
      # haskell
      haskellPackages.cabal-fmt
      haskellPackages.haskell-language-server
      haskellPackages.ormolu
      # html
      superhtml
      # json
      vscode-json-languageserver
      yaml-language-server
      # lua
      emmylua-ls
      # markdown
      marksman
      # nginx
      # nginx-language-server
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
      bash-language-server
      shellcheck
      shfmt
      # sql
      postgres-language-server
      squawk
      # sqruff
      # terraform
      terraform-ls
      # typescript
      vtsls
      # typst
      tinymist
      # zig
      zls
      # other
      efm-langserver
      harper
      # typespec # broken
    ];
  };

  abolish = {
    src = inputs.vim-abolish;
  };

  conform = {
    src = inputs.conform;
    config = ./conform.lua;
    paths = with pkgs; [
      jq
      kulala-fmt
      prettier
      stylua
    ];
  };

  dap = {
    package = buildVimPlugin {
      name = "dap";
      src = inputs.nvim-dap;
    };
    config = ./dap.lua;
    dependencies = {
      dapui.package = buildVimPlugin {
        name = "dapui";
        src = inputs.nvim-dap-ui;
        doCheck = false;
        doInstallCheck = true;
      };
      nio.package = buildVimPlugin {
        name = "nio";
        src = inputs.nvim-nio;
      };
      nvim-dap-virtual-text = {
        package = buildVimPlugin {
          name = "nvim-dap-virtual-text";
          src = inputs.nvim-dap-virtual-text;
          doCheck = false;
        };
        config = true;
      };
      nvim-dap-vscode-js = {
        package = buildVimPlugin {
          name = "nvim-dap-vscode-js";
          src = inputs.nvim-dap-vscode-js;
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
    # NOTE: broken, but also unused, as of 10/16/25
    # paths = with pkgs.haskellPackages; [
    #   haskell-debug-adapter
    # ];
  };

  dial = {
    src = inputs.dial;
    config = ./dial.lua;
  };

  diffconflicts.src = inputs.jj-diffconflicts;

  fidget = {
    src = inputs.fidget;
    config.progress.ignore = ["null-ls"];
  };

  flatten = {
    src = inputs.flatten;
    config.window.open = "alternate";
    lazy = false;
    priority = 1001;
  };

  fugitive.src = inputs.vim-fugitive;

  gitsigns = {
    package = buildVimPlugin {
      name = "gitsigns.nvim";
      src = inputs.gitsigns;
      nvimRequireCheck = "gitsigns";
      dependencies = [plenary.package];
    };
    config = ./gitsigns.lua;
  };

  grug-far = {
    src = inputs.grug-far;
    config = ./grug.lua;
    paths = with pkgs; [
      ast-grep
      ripgrep
    ];
  };

  hunk = {
    package = buildVimPlugin {
      name = "hunk.nvim";
      src = inputs.hunk;
      dependencies = [nui.package];
    };
    config = ./hunk.lua;
    dependencies = {inherit nui;};
  };

  ibl = {
    package = buildVimPlugin {
      name = "ibl";
      src = inputs.indent-blankline;
      nvimSkipModule = "ibl.config.types";
    };
    config = ./indent-blankline.lua;
  };

  iron = {
    src = inputs.iron;
    config = ./iron.lua;
    paths = [pkgs.bun];
  };

  leap = {
    src = inputs.leap;
    config = ./leap.lua;
  };

  leetcode = {
    package = buildVimPlugin {
      name = "leetcode.nvim";
      src = inputs.leetcode;
      doCheck = false;
    };
    dependencies = {inherit telescope plenary nui;};
    config = {
      lang = "typescript";
      picker.provider = "telescope";
    };
  };

  vim-markdown = {
    src = inputs.vim-markdown;
    config = ./markdown.lua;
  };

  matchup.package = buildVimPlugin {
    name = "matchup";
    src = inputs.vim-matchup;
    nvimRequireCheck = "match-up";
  };

  "mini.icons" = {
    src = inputs.mini-icons;
    config = true;
  };

  nui.package = buildVimPlugin {
    name = "nui";
    src = inputs.nui;
  };

  nvim-surround = {
    package = buildVimPlugin {
      name = "nvim-surround";
      src = inputs.nvim-surround;
      nvimSkipModule = "nvim-surround.queries";
    };
    config = true;
  };

  nvim-ts-context-commentstring = {
    src = inputs.nvim-ts-context-commentstring;
    config = ./comment.lua;
  };

  plenary = {
    package = pkgs.vimPlugins.plenary-nvim.overrideAttrs (_: {
      src = inputs.plenary;
    });
  };

  quicker = {
    src = inputs.quicker;
    config = ./quicker.lua;
  };

  repeat.src = inputs.vim-repeat;

  review = {
    package = buildVimPlugin {
      name = "review.nvim";
      src = inputs.review;
      nvimSkipModule = "review.picker"; # FIXME
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/georgeguimaraes/review.nvim/commit/50a8b549be1cc4b0197b02d9684b9c5724629080.patch";
          hash = "sha256-8eK7OeUzcgHQYEE7jKNwaSXwjR+s5Bby2EyY8CoyDiY=";
        })
      ];
    };
    config = ./review.lua;
    dependencies = {
      codediff.package = pkgs.vimPlugins.codediff-nvim;
    };
  };

  sqlite = {
    package = buildVimPlugin {
      name = "sqlite.lua";
      src = inputs.sqlite;
      nvimRequireCheck = "sqlite";
    };
    cpath = "${pkgs.sqlite.out}/lib/?.so";
    init = ./sqlite.lua;
  };

  statuscol = {
    src = inputs.statuscol;
    config = {
      setopt = true;
    };
  };

  tabout = {
    src = inputs.tabout;
    config = ./tabout.lua;
  };

  telescope = {
    config = ./telescope.lua;
    dependencies = {
      telescope-fzf-native = {
        package = buildVimPlugin {
          name = "telescope-fzf-native";
          buildPhase = "make";
          dependencies = [telescope.package];
          src = inputs.telescope-fzf-native;
        };
      };
      telescope-live-grep-args = {
        package = buildVimPlugin {
          name = "telescope-live-grep-args";
          src = inputs.telescope-live-grep-args;
          paths = with pkgs; [ripgrep];
          doCheck = false;
          doInstallCheck = true;
        };
      };
      telescope-smart-open = {
        package = buildVimPlugin {
          name = "smart-open.nvim";
          src = inputs.smart-open;
          doCheck = false;
          doInstallCheck = true;
        };
        dependencies = {inherit sqlite;};
        paths = with pkgs; [ripgrep];
      };
      telescope-symbols = {
        src = inputs.telescope-symbols;
      };
      telescope-ui-select = {
        src = inputs.telescope-ui-select;
      };
      telescope-undo = {
        package = buildVimPlugin {
          name = "telescope-undo";
          src = inputs.telescope-undo;
          dependencies = [
            plenary.package
            telescope.package
          ];
        };
        paths = with pkgs; [delta];
      };
    };
    package = buildVimPlugin {
      name = "telescope";
      src = inputs.telescope;
      dependencies = [plenary.package];
    };
    paths = with pkgs; [
      fd
      ripgrep
    ];
  };

  toggleterm = {
    src = inputs.toggleterm;
    config = ./toggleterm.lua;
  };
}
