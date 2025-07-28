{
  buildGoModule,
  fetchFromGitHub,
  vimUtils,
  arrow-cpp,
  duckdb,
  ...
}: let
  version = "0.1.9-unstable-2025-07-25";
  src = fetchFromGitHub {
    owner = "kndndrj";
    repo = "nvim-dbee";
    rev = "dda517694889a5d238d7aa407403984da9f80cc0";
    hash = "sha256-rvKUqUsLpGYqDVNeRVUlEPkpntahFDx4qJH7a5Uw760=";
  };
  dbee = buildGoModule {
    pname = "dbee";
    inherit version src;
    sourceRoot = "source/dbee";
    vendorHash = "sha256-ah3gpaL1XSlktQNCE8sHNLJtKY5zBNNNDetinq/zySM=";
    buildInputs = [arrow-cpp duckdb];
    doCheck = false;
  };
in
  vimUtils.buildVimPlugin {
    pname = "nvim-dbee";
    inherit version src;
    doCheck = false;
    nvimRequireCheck = "dbee";
    propagatedBuildInputs = [dbee];
    inherit dbee;
  }
