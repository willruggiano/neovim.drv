{
  buildGoModule,
  vimUtils,
  arrow-cpp,
  duckdb,
  ...
}: let
  sources = import ../nix/sources.nix {};
  bin = buildGoModule {
    name = "dbee";
    src = sources.nvim-dbee;
    sourceRoot = "source/dbee";
    vendorHash = "sha256-U/3WZJ/+Bm0ghjeNUILsnlZnjIwk3ySaX3Rd4L9Z62A=";
    buildInputs = [arrow-cpp duckdb];
  };
in
  vimUtils.buildVimPlugin {
    name = "nvim-dbee";
    src = sources.nvim-dbee;
    nvimRequireCheck = "dbee";
    propagatedBuildInputs = [bin];
    passthru.dbee = bin;
  }
