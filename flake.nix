{
  inputs = {
    devenv = {
      url = "github:cachix/devenv";
      inputs.git-hooks.follows = "git-hooks";
    };
    git-hooks.url = "github:cachix/git-hooks.nix";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nix = {
      # url = "path:///home/bombadil/dev/neovim.nix";
      url = "github:willruggiano/neovim.nix";
      inputs.example.follows = "";
      inputs.flake-parts.follows = "flake-parts";
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
    sg-nvim.url = "github:sourcegraph/sg.nvim";
    vscode-js-debug.url = "github:willruggiano/vscode-js-debug.nix";
    zls.url = "github:zigtools/zls";
  };

  nixConfig = {
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://nix-community.cachix.org"
      "https://willruggiano.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "willruggiano.cachix.org-1:rz00ME8/uQfWe+tN3njwK5vc7P8GLWu9qbAjjJbLoSw="
    ];
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
        inputs.neovim-nix.flakeModule
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
            runtimeInputs = with pkgs; [niv];
            text = ''
              nix flake update &&
              niv update &&
              nix run .#nvim-treesitter.update-grammars &&
              nix flake check --impure
            '';
          };
        };

        devenv.shells.default = {
          name = "neovim";
          # https://github.com/cachix/devenv/issues/528
          containers = lib.mkForce {};
          packages = with pkgs; [alejandra just niv nodejs tree-sitter];
          pre-commit.hooks = {
            alejandra.enable = true;
            stylua.enable = true;
          };
          scripts = {
            plug-add.exec = ''
              niv add git git@github.com:$1 && git add -A
            '';
          };
        };

        formatter = pkgs.alejandra;

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
          ivy = pkgs.callPackage ./pkgs/ivy {};
          kulala-fmt = pkgs.callPackage ./pkgs/kulala-fmt {};
          luafun = pkgs.luajit.pkgs.callPackage ./pkgs/luafun.nix {};
          neovim-nightly = inputs'.neovim.packages.default;
          nvim = config.neovim.final;
          nvim-dbee = pkgs.callPackage ./pkgs/nvim-dbee.nix {};
          nvim-treesitter = pkgs.callPackage ./pkgs/nvim-treesitter {};
          sqruff = pkgs.callPackage ./pkgs/sqruff.nix {inherit inputs;};
        };
      };
    };
}
