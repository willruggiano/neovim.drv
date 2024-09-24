{
  callPackage,
  fetchFromGitHub,
  inputs,
  rust-bin,
  ...
}: let
  src = fetchFromGitHub {
    owner = "quarylabs";
    repo = "sqruff";
    rev = "v0.18.0";
    hash = "sha256-4UAO+d5pWatra1g5/+xHn/9B1wVCnDyNJFkDr+G9DXc=";
  };
  toolchain = rust-bin.fromRustupToolchainFile "${src}/rust-toolchain.toml";

  naersk = callPackage inputs.naersk {
    cargo = toolchain;
    rustc = toolchain;
  };
in
  naersk.buildPackage {
    inherit src;
  }
