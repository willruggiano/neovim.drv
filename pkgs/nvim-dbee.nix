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
    vendorHash = "sha256-JkZPqasidkFDhxVt/6OJhu4rHaY7qWxHv7MOnsIjuS0=";
    buildInputs = [duckdb];
  };
in
  vimUtils.buildVimPlugin {
    name = "nvim-dbee";
    src = sources.nvim-dbee;
    propagatedBuildInputs = [bin];
    passthru.dbee = bin;
  }
