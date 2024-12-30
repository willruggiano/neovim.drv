{
  rustPlatform,
  vimUtils,
}: let
  sources = import ../../nix/sources.nix;
in
  rustPlatform.buildRustPackage rec {
    name = "ivy";
    src = sources."ivy.nvim";
    cargoHash = "sha256-YaDp+w+/68rs8pGl7iQX1au2Aouk0ex17d75drFX1HI=";

    passthru.vimPlugin = vimUtils.buildVimPlugin {
      inherit name src;
      patches = [
        ./ivy-origin-api-missing.patch
        ./use-package-cpath.patch
      ];
      doCheck = false;
    };
  }
