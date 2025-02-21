{
  callPackage,
  cmake,
  inputs,
  protobuf,
  rust-bin,
  rustPlatform,
  ...
}: let
  src = (import ../../nix/sources.nix {}).postgres_lsp;
  toolchain = rust-bin.fromRustupToolchainFile "${src}/rust-toolchain.toml";

  naersk = callPackage inputs.naersk {
    cargo = toolchain;
    rustc = toolchain;
  };
in
  naersk.buildPackage {
    inherit src;
    nativeBuildInputs = [cmake protobuf rustPlatform.bindgenHook];
    RUSTC_BOOTSTRAP = 1;
  }
