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
    vendorHash = "sha256-AItvgOehVskGLARJWDnJLtWM5YHKN/zn/FnZQ0evAtI=";
    buildInputs = [duckdb];
  };
in
  vimUtils.buildVimPlugin {
    name = "nvim-dbee";
    src = sources.nvim-dbee;
    propagatedBuildInputs = [bin];
    passthru.dbee = bin;
  }
