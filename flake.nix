{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim-nix.url = "github:willruggiano/neovim.nix";
    pre-commit.url = "github:cachix/pre-commit-hooks.nix";
    sg-nvim.url = "github:sourcegraph/sg.nvim";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
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
        apps = {
          default.program = config.neovim.final;
          update-grammars.program = nvim-treesitter.update-grammars;
        };

        devShells.default = pkgs.mkShell {
          name = "neovim";
          buildInputs = with pkgs; with nodePackages; [niv nodejs];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        packages = {
          default = config.neovim.final;
          inherit nvim-treesitter;
        };

        pre-commit = {
          settings = {
            hooks.alejandra.enable = true;
            hooks.stylua.enable = true;
          };
        };
      };
    };
}
