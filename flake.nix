{
  inputs = {
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    neovim-nix.inputs.neovim.follows = "neovim";
    neovim-nix.url = "github:willruggiano/neovim.nix";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
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
        apps.default.program = config.neovim.final;

        devenv.shells.default = {
          name = "neovim";
          packages = with pkgs; [niv nodejs];
          pre-commit.hooks = {
            alejandra.enable = true;
            stylua.enable = true;
          };
          scripts = {
            bump-neovim.exec = ''
              nix flake lock --update-input neovim &&
                nom build &&
                git commit -am 'bump: neovim'
            '';
            bump-nvim-treesitter.exec = ''
              niv update nvim-treesitter &&
                nix run .#nvim-treesitter.update-grammars -- ./pkgs/nvim-treesitter &&
                git commit -am 'bump: nvim-treesitter'
            '';
            bump-plugin.exec = ''
              [ $# -eq 0 ] && {
                niv update &&
                  git commit -am "bump: all plugins"
              } || {
                niv update $1 &&
                  git commit -am "bump: $1"
              }
            '';
            plug-add.exec = ''
              niv add git git@github.com:$1 && git add nix/ && git commit -am "feat(plug): $1"
            '';
          };
        };

        packages = {
          default = config.neovim.final;
          nvim-dbee = pkgs.callPackage ./pkgs/nvim-dbee.nix {};
          nvim-treesitter = pkgs.callPackage ./pkgs/nvim-treesitter {};
        };
      };
    };
}
