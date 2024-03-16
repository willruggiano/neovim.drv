{
  inputs = {
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    neovim-nix = {
      url = "github:willruggiano/neovim.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    neovim.url = "github:neovim/neovim/nightly?dir=contrib";
    nil.url = "github:oxalica/nil";
    # FIXME: see https://github.com/cachix/devenv/issues/528
    nix2container.url = "github:nlewo/nix2container";
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
        ./neovim.nix
      ];

      systems = ["aarch64-darwin" "x86_64-linux"];
      perSystem = {
        config,
        pkgs,
        inputs',
        ...
      }: {
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

              cachix pin willruggiano nvim-drv "$(nix build --accept-flake-config --print-out-paths)"
            '';
          };
          update.program = pkgs.writeShellApplication {
            name = "update.sh";
            text = ''
              nix flake update &&
              niv update &&
              nix run .#nvim-treesitter.update-grammars -- ./pkgs/nvim-treesitter
            '';
          };
        };

        devenv.shells.default = {
          name = "neovim";
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
          };
          nvim-dbee = pkgs.callPackage ./pkgs/nvim-dbee.nix {};
          nvim-treesitter = pkgs.callPackage ./pkgs/nvim-treesitter {};
        };
      };
    };
}
