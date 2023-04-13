{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nix.url = "github:willruggiano/neovim.nix";
    neovim.url = "github:neovim/neovim?dir=contrib";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
    sg-nvim.url = "github:sourcegraph/sg.nvim";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
        inputs.neovim-nix.flakeModule
        inputs.pre-commit.flakeModule
        ./neovim.nix
      ];

      systems = ["x86_64-linux"];
      perSystem = {
        config,
        pkgs,
        inputs',
        ...
      }: let
        nvim-treesitter = pkgs.callPackage ./pkgs/nvim-treesitter {};
      in {
        apps.default.program = config.neovim.final;

        devenv.shells.default = {
          name = "neovim";
          packages = with pkgs; [niv nodejs];
          pre-commit.hooks = {
            alejandra.enable = true;
            stylua.enable = true;
          };
          scripts = {
            update-grammars.exec = ''
              nix run .#nvim-treesitter.update-grammars -- ./pkgs/nvim-treesitter
              git commit -am 'chore: update treesitter grammars'
            '';
            update-plugin.exec = ''
              niv update $1
              git commit -am "chore: update $1"
            '';
          };
        };

        packages = {
          default = config.neovim.final;
          inherit nvim-treesitter;
        };
      };
    };
}
