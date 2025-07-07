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
    rev = "v0.28.0";
    hash = "sha256-85QNbLcc2zIa+MitLaTPePdkXMneZJRGHbfSN0iNkKA=";
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
