{
  inputs = {
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
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
      inputs = {
        git-hooks.follows = "";
        hercules-ci-effects.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };

    blink = {
      url = "github:Saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil.url = "github:oxalica/nil";
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-js-debug.url = "github:willruggiano/vscode-js-debug.nix";
    zls.url = "github:zigtools/zls";
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

      systems = ["aarch64-darwin" "x86_64-linux"];
      perSystem = {
        config,
        lib,
        inputs',
        system,
        ...
      }: let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.rust-overlay.overlays.default
            (final: prev: {
              neovim-unwrapped = config.packages.neovim-nightly;
            })
          ];
        };
      in {
        _module.args = {
          inherit pkgs;
          nix-colors =
            inputs.nix-colors.lib
            // {
              contrib = inputs.nix-colors.lib-contrib {inherit pkgs;};
              schemes = inputs.nix-colors.colorSchemes;
            };
        };

        apps = {
          push.program = pkgs.writeShellApplication {
            name = "push.sh";
            runtimeInputs = with pkgs; [cachix jq];
            text = ''
              nix flake archive --json \
              | jq -r '.path,(.inputs|to_entries[].value.path)' \
              | cachix push willruggiano;

              nix build --json \
              | jq -r '.[].outputs | to_entries[].value' \
              | cachix push willruggiano;

              cachix pin willruggiano nvim-drv "$(nix build --print-out-paths)"
            '';
          };
          update.program = pkgs.writeShellApplication {
            name = "update.sh";
            runtimeInputs = with pkgs; [niv nix-update];
            text = ''
              nix flake update &&
              niv update &&
              nix run .#nvim-treesitter.updateScript &&
              nix-update --flake nvim-dbee --version=branch --subpackage dbee &&
              nix-update --flake sqruff --version-regex='v(.*)' --override-filename pkgs/sqruff.nix &&
              nix flake check
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          name = "neovim";
          inputsFrom = [
            config.pre-commit.devShell
          ];
          buildInputs = with pkgs; [alejandra just niv nix-update];
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
          darkman-nvim = pkgs.callPackage ./pkgs/darkman-nvim {};
          # Not buildable since switch to bun
          # kulala-fmt = pkgs.callPackage ./pkgs/kulala-fmt {};
          luafun = pkgs.luajit.pkgs.callPackage ./pkgs/luafun.nix {};
          neovim-nightly = inputs'.neovim.packages.default;
          nvim = config.neovim.final;
          nvim-rplugin = config.neovim.build.rplugin;
          nvim-dbee = pkgs.callPackage ./pkgs/nvim-dbee.nix {};
          nvim-treesitter = pkgs.callPackage ./pkgs/nvim-treesitter {};
          postgrestools = pkgs.callPackage ./pkgs/postgres_lsp {};
          # Currently not buildable with nix :(
          # postgres_lsp = pkgs.callPackage ./pkgs/postgres_lsp {inherit inputs;};
          sqruff = pkgs.callPackage ./pkgs/sqruff.nix {inherit inputs;};
        };

        pre-commit.settings = {
          hooks.treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };
        };

        treefmt.config = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            prettier.enable = true;
            stylua.enable = true;
          };
          settings.global.excludes = ["*.vim" "*.scm" "*.snip*" "*.toml" "justfile" "nix/sources.json"];
        };
      };
    };
}
