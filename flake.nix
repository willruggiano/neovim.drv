{
  inputs = {
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nix = {
      url = "github:willruggiano/neovim.nix";
      inputs.example.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.git-hooks.follows = ""; FIXME: SO :(
    };
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # plugins
    clangd-ext = {
      url = "github:p00f/clangd_extensions.nvim";
      flake = false;
    };
    conform = {
      url = "github:stevearc/conform.nvim";
      flake = false;
    };
    dial = {
      url = "github:monaqa/dial.nvim";
      flake = false;
    };
    doom-one = {
      url = "github:NTBBloodbath/doom-one.nvim";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    flatten = {
      url = "github:willothy/flatten.nvim";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    grug-far = {
      url = "github:magicduck/grug-far.nvim";
      flake = false;
    };
    hunk = {
      url = "github:julienvincent/hunk.nvim";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    iron = {
      url = "github:vigemus/iron.nvim";
      flake = false;
    };
    jj-diffconflicts = {
      url = "github:rafikdraoui/jj-diffconflicts";
      flake = false;
    };
    leap = {
      url = "git+https://codeberg.org/andyg/leap.nvim.git";
      flake = false;
    };
    leetcode = {
      url = "github:kawre/leetcode.nvim";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };
    mini-icons = {
      url = "github:nvim-mini/mini.icons";
      flake = false;
    };
    nui = {
      url = "github:muniftanjim/nui.nvim";
      flake = false;
    };
    nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    nvim-dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    nvim-nio = {
      url = "github:nvim-neotest/nvim-nio";
      flake = false;
    };
    nvim-dap-virtual-text = {
      url = "github:thehamsta/nvim-dap-virtual-text";
      flake = false;
    };
    nvim-dap-vscode-js = {
      url = "github:mxsdev/nvim-dap-vscode-js";
      flake = false;
    };
    nvim-lsp-file-ops = {
      url = "github:antosha417/nvim-lsp-file-operations";
      flake = false;
    };
    nvim-surround = {
      url = "github:kylechui/nvim-surround";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter?ref=main";
      flake = false;
    };
    nvim-ts-context-commentstring = {
      url = "github:JoosepAlviste/nvim-ts-context-commentstring";
      flake = false;
    };
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    quicker = {
      url = "github:stevearc/quicker.nvim";
      flake = false;
    };
    schemastore = {
      url = "github:b0o/SchemaStore.nvim";
      flake = false;
    };
    smart-open = {
      url = "github:danielfalk/smart-open.nvim";
      flake = false;
    };
    sqlite = {
      url = "github:kkharji/sqlite.lua";
      flake = false;
    };
    statuscol = {
      url = "github:luukvbaal/statuscol.nvim";
      flake = false;
    };
    tabout = {
      url = "github:abecodes/tabout.nvim";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-fzf-native = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    telescope-live-grep-args = {
      url = "github:nvim-telescope/telescope-live-grep-args.nvim";
      flake = false;
    };
    telescope-symbols = {
      url = "github:nvim-telescope/telescope-symbols.nvim";
      flake = false;
    };
    telescope-ui-select = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };
    telescope-undo = {
      url = "github:debugloop/telescope-undo.nvim";
      flake = false;
    };
    toggleterm = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };
    vim-abolish = {
      url = "github:tpope/vim-abolish";
      flake = false;
    };
    vim-fugitive = {
      url = "github:tpope/vim-fugitive";
      flake = false;
    };
    vim-markdown = {
      url = "github:preservim/vim-markdown";
      flake = false;
    };
    vim-matchup = {
      url = "github:andymass/vim-matchup";
      flake = false;
    };
    vim-repeat = {
      url = "github:tpope/vim-repeat";
      flake = false;
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://willruggiano.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "willruggiano.cachix.org-1:rz00ME8/uQfWe+tN3njwK5vc7P8GLWu9qbAjjJbLoSw="
    ];
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.git-hooks.flakeModule
        inputs.neovim-nix.flakeModule
        inputs.treefmt.flakeModule
        ./modules
      ];

      systems = ["x86_64-linux"];
      perSystem = {
        config,
        lib,
        inputs',
        system,
        ...
      }: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["claude-code"];
          overlays = [
            inputs.rust-overlay.overlays.default
            (final: prev: {
              neovim-unwrapped = config.packages.neovim-nightly;
            })
          ];
        };
      in {
        _module.args = {inherit pkgs;};

        devShells.default = pkgs.mkShell {
          name = "neovim";
          inputsFrom = [
            config.pre-commit.devShell
          ];
          buildInputs = with pkgs; [
            alejandra
            cachix
            jq
            just
          ];
          shellHook = let
            emmyrc = pkgs.writeText "emmyrc" (builtins.toJSON {
              "$schema" = "https://raw.githubusercontent.com/EmmyLuaLs/emmylua-analyzer-rust/refs/heads/main/crates/emmylua_code_analysis/resources/schema.json";
              runtime = {
                version = "LuaJIT";
                requirePattern = [
                  "lua/?.lua"
                  "lua/?/init.lua"
                ];
              };
              workspace = {
                library = ["${config.packages.neovim-nightly}/share/nvim/runtime"];
              };
            });
          in ''
            ln -sf ${emmyrc} .emmyrc.json
          '';
        };

        packages = {
          default = pkgs.symlinkJoin {
            name = "nvim-bin";
            paths = [
              config.neovim.final # `nvim`
              (pkgs.writeShellScriptBin "fvim" ''
                nvim +'Telescope smart_open'
              '')
            ];
            meta.mainProgram = "nvim";
          };
          neovim-nightly = inputs'.neovim.packages.default;
          nvim = config.neovim.final;
          nvim-rplugin = config.neovim.build.rplugin;
        };

        pre-commit.settings = {
          hooks = {
            treefmt = {
              enable = true;
              package = config.treefmt.build.wrapper;
            };
            zizmor = {
              enable = true;
              files = "^.github/"; # include dependabot.yml
            };
          };
        };

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            prettier.enable = true;
            stylua.enable = true;
          };
          settings.global.excludes = ["*.vim" "*.scm" "*.snip*" "*.toml" "justfile"];
        };
      };
    };
}
