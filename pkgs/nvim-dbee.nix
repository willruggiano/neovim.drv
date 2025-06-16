{
  buildGoModule,
  fetchFromGitHub,
  vimUtils,
  arrow-cpp,
  duckdb,
  ...
}: let
  version = "0.1.9-unstable-2025-06-13";
  src = fetchFromGitHub {
    owner = "kndndrj";
    repo = "nvim-dbee";
    rev = "044e016127e63428b8d54116943cad29457db665";
    hash = "sha256-0AA36Z2EqxdfT7ZLB6LS5EEh6yj22LQxD1XW/MmDSac=";
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
