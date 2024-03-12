{
  buildGoModule,
  vimUtils,
  duckdb,
  fetchpatch,
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
    patches = [
      (fetchpatch {
        name = "fix-docs-remove-duplicate-tags.patch";
        url = "https://patch-diff.githubusercontent.com/raw/kndndrj/nvim-dbee/pull/78.patch";
        hash = "sha256-SM1Hu77rO4KlfYat6Xj9AIGG7ui35zhejRE5Wa/L2V0=";
      })
    ];
    propagatedBuildInputs = [bin];
    passthru.dbee = bin;
  }
