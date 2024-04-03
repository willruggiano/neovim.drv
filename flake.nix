{
  inputs = {
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nix = {
      url = "github:willruggiano/neovim.nix";
      inputs.flake-parts.follows = "flake-parts";
    };
    neovim.url = "github:neovim/neovim/nightly?dir=contrib";
    nil.url = "github:oxalica/nil";
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    sg-nvim.url = "github:sourcegraph/sg.nvim";
    vscode-js-debug.url = "github:willruggiano/vscode-js-debug.nix";
    zls.url = "github:zigtools/zls";
  };

  nixConfig = {
    extra-substituters = [
      "https://willruggiano.cachix.org"
    ];
    extra-trusted-public-keys = [
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
        pkgs,
        inputs',
        ...
      }: {
        _module.args.nix-colors =
          inputs.nix-colors.lib
          // {
            contrib = inputs.nix-colors.lib-contrib {inherit pkgs;};
            schemes = inputs.nix-colors.colorSchemes;
          };

        apps = {
          push.program = pkgs.writeShellApplication {
            name = "push.sh";
            runtimeInputs = with pkgs; [cachix jq];
            text = ''
              nix flake archive --accept-flake-config --json \
              | jq -r '.path,(.inputs|to_entries[].value.path)' \
              | cachix push willruggiano;

              nix build --accept-flake-config --json \
              | jq -r '.[].outputs | to_entries[].value' \
              | cachix push willruggiano;

              cachix pin willruggiano nvim-drv "$(nix build --accept-flake-config --print-out-paths)"
            '';
          };
          update.program = pkgs.writeShellApplication {
            name = "update.sh";
            runtimeInputs = with pkgs; [niv];
            text = ''
              nix flake update --accept-flake-config &&
              niv update &&
              nix run .#nvim-treesitter.update-grammars -- ./pkgs/nvim-treesitter &&
              git commit -am 'chore: 🌶️🌶️🌶️' &&
              git push
            '';
          };
        };

        devenv.shells.default = {
          name = "neovim";
          # https://github.com/cachix/devenv/issues/528
          containers = lib.mkForce {};
          packages = with pkgs; [alejandra just niv nodejs];
          pre-commit.hooks = {
            alejandra.enable = true;
            stylua.enable = true;
          };
          scripts = {
            plug-add.exec = ''
              niv add git git@github.com:$1 && git add -A && git commit -am "feat(plug): $1"
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
          nvim = config.neovim.final;
          nvim-dbee = pkgs.callPackage ./pkgs/nvim-dbee.nix {};
          nvim-treesitter = pkgs.callPackage ./pkgs/nvim-treesitter {};
        };
      };
    };
}
