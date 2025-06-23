{
  callPackage,
  fetchFromGitHub,
  inputs,
  rust-bin,
  python3,
  ...
}: let
  src = fetchFromGitHub {
    owner = "quarylabs";
    repo = "sqruff";
    rev = "v0.26.8";
    hash = "sha256-tAlyuDo/fIbdeTun8Edz7r1974fp9Uc+bBO28o39Vww=";
  };
  toolchain = rust-bin.fromRustupToolchainFile "${src}/rust-toolchain.toml";

  naersk = callPackage inputs.naersk {
    cargo = toolchain;
    rustc = toolchain;
  };
in
  naersk.buildPackage {
    inherit src;
    nativeBuildInputs = [python3];
  }
