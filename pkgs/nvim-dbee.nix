{
  buildGoModule,
  vimUtils,
  duckdb,
  ...
}: let
  sources = import ../nix/sources.nix {};
  bin = buildGoModule {
    name = "dbee";
    src = sources.nvim-dbee;
    sourceRoot = "source/dbee";
    vendorHash = "sha256-0TIKX0OL5V3sk9V7e56YmNIzsUZku6Y8S22lVUGrsCY=";
    buildInputs = [duckdb];
  };
in
  vimUtils.buildVimPlugin {
    name = "nvim-dbee";
    src = sources.nvim-dbee;
    propagatedBuildInputs = [bin];
    passthru.dbee = bin;
  }
