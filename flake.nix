{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim.url = "github:neovim/neovim?dir=contrib";
    neovim-nix.url = "github:willruggiano/neovim.nix";
    sg-nvim.url = "github:sourcegraph/sg.nvim";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.neovim-nix.flakeModule
        ./neovim.nix
      ];

      systems = ["x86_64-linux"];
      perSystem = {
        config,
        pkgs,
        inputs',
        ...
      }: {
        apps.default.program = config.neovim.final;
        devShells.default = pkgs.mkShell {
          name = "neovim";
          buildInputs = with pkgs; [niv];
        };
        packages = {
          default = config.neovim.final;
        };
      };
    };
}
