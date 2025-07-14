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
    rev = "v0.28.2";
    hash = "sha256-a4B8X4Jv18m3NutdEgO9pIWxVfe9prTjwsyFolZrkCk=";
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
