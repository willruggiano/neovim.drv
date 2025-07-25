{
  inputs = {
    blink = {
      url = "github:Saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    mcp-hub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
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
          config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["claude-code"];
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
            niv
            nix-update
          ];
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
          luafun = pkgs.luajit.pkgs.callPackage ./pkgs/luafun.nix {};
          neovim-nightly = inputs'.neovim.packages.default;
          nvim = config.neovim.final;
          nvim-rplugin = config.neovim.build.rplugin;
          nvim-dbee = pkgs.callPackage ./pkgs/nvim-dbee.nix {};
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
