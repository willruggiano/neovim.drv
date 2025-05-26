{
  buildGoModule,
  fetchFromGitHub,
  vimUtils,
  arrow-cpp,
  duckdb,
  ...
}: let
  version = "0.1.9-unstable-2025-05-21";
  src = fetchFromGitHub {
    owner = "kndndrj";
    repo = "nvim-dbee";
    rev = "9656fc59841291e9dbd2f3b50b1cb4c77d9fea79";
    hash = "sha256-iVJfJKswYTJ+1Gtfn1rISSRpIPvxlYOWb0k8h9paqhU=";
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
