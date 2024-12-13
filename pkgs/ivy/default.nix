{
  rustPlatform,
  vimUtils,
}: let
  sources = import ../../nix/sources.nix;
in
  rustPlatform.buildRustPackage rec {
    name = "ivy";
    src = sources."ivy.nvim";
    cargoHash = "sha256-sm+CP0bpD8VlB5zjA56cZuntQ8mpXwqbaeNNxugRloA=";

    passthru.vimPlugin = vimUtils.buildVimPlugin {
      inherit name src;
      patches = [
        ./ivy-origin-api-missing.patch
        ./use-package-cpath.patch
      ];
    };
  }
