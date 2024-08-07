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
    rev = "v0.11.1";
    hash = "sha256-tAnfkeDou6OLTd9jnGxqLu8ydB8vTa+MQ7utCcua7zQ=";
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
