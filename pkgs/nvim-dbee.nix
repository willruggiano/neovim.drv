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
    vendorHash = "sha256-uvTm3qolnSs7h21H0lWedjSvjkmIIvDrsEYZQr2RxYk=";
    buildInputs = [arrow-cpp duckdb];
    doCheck = false;
  };
in
  vimUtils.buildVimPlugin {
    name = "nvim-dbee";
    src = sources.nvim-dbee;
    nvimRequireCheck = "dbee";
    propagatedBuildInputs = [bin];
    passthru.dbee = bin;
  }
