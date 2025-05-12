{
  buildGoModule,
  fetchFromGitHub,
  vimUtils,
  arrow-cpp,
  duckdb,
  ...
}: let
  version = "0.1.9-unstable-2025-05-08";
  src = fetchFromGitHub {
    owner = "kndndrj";
    repo = "nvim-dbee";
    rev = "ece254aaa322962659321f10329f408775b4beff";
    hash = "sha256-Ks+uBjxLGnQH/fy+8ZyvGVKPu68Ckch9K8OtiHO5RBk=";
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
