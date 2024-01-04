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
    vendorHash = "sha256-ef/LmaI85+R3YCdS0mqGtY1aulN56bNxLW2lgBlTTwI=";
    buildInputs = [duckdb];
  };
in
  vimUtils.buildVimPlugin {
    name = "nvim-dbee";
    src = sources.nvim-dbee;
    propagatedBuildInputs = [bin];
    passthru.dbee = bin;
  }
