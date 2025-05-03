{
  buildGoModule,
  fetchFromGitHub,
  vimUtils,
  arrow-cpp,
  duckdb,
  ...
}: let
  version = "0.1.9-unstable-2025-03-24";
  src = fetchFromGitHub {
    owner = "kndndrj";
    repo = "nvim-dbee";
    rev = "b4aebcabedbf0f5aa90ca391c87d6095e365ac33";
    hash = "sha256-AZojgGP8SbPywWlxyeKa5aijK6QgACbRu9q4po+grqc=";
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
