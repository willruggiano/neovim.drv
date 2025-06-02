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
    rev = "v0.26.4";
    hash = "sha256-JDnbJxjK4r/OVXTQQhEbzKhOxA8GO43XGRPHQyeXHGc=";
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
