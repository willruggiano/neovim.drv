# Straight copy from nixpkgs, until https://github.com/NixOS/nixpkgs/pull/284045 is merged.
{
  lib,
  stdenv,
  fetchFromGitHub,
  which,
  rustPlatform,
  emscripten,
  darwin,
  callPackage,
  tree-sitter,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  webUISupport ? false,
}: let
  version = "0.20.9";
  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    rev = "v${version}";
    hash = "sha256-NxWqpMNwu5Ajffw1E2q9KS4TgkCH6M+ctFyi9Jp0tqQ=";
    fetchSubmodules = true;
  };
in
  rustPlatform.buildRustPackage {
    pname = "tree-sitter";
    inherit src version;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "cranelift-bforest-0.102.0" = "sha256-rJeRbRDrAnKb8s98gNn1NTMKuB8B4aOI8Fh6JeLX7as=";
      };
    };

    buildInputs =
      lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [CoreServices Security]);
    nativeBuildInputs =
      [which]
      ++ lib.optionals webUISupport [emscripten];

    postPatch = lib.optionalString (!webUISupport) ''
      # remove web interface
      sed -e '/pub mod playground/d' \
          -i cli/src/lib.rs
      sed -e 's/playground,//' \
          -e 's/playground::serve(&current_dir.*$/println!("ERROR: web-ui is not available in this nixpkgs build; enable the webUISupport"); std::process::exit(1);/' \
          -i cli/src/main.rs
    '';

    # Compile web assembly with emscripten. The --debug flag prevents us from
    # minifying the JavaScript; passing it allows us to side-step more Node
    # JS dependencies for installation.
    preBuild = lib.optionalString webUISupport ''
      mkdir -p .emscriptencache
      export EM_CACHE=$(pwd)/.emscriptencache
      bash ./script/build-wasm --debug
    '';

    postInstall = ''
      PREFIX=$out make install
      ${lib.optionalString (!enableShared) "rm $out/lib/*.so{,.*}"}
      ${lib.optionalString (!enableStatic) "rm $out/lib/*.a"}
    '';

    doCheck = false;

    inherit (tree-sitter) passthru;
    # passthru.buildGrammar = callPackage ./buildGrammar.nix {};

    meta = with lib; {
      homepage = "https://github.com/tree-sitter/tree-sitter";
      description = "A parser generator tool and an incremental parsing library";
      longDescription = ''
        Tree-sitter is a parser generator tool and an incremental parsing library.
        It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.

        Tree-sitter aims to be:

        * General enough to parse any programming language
        * Fast enough to parse on every keystroke in a text editor
        * Robust enough to provide useful results even in the presence of syntax errors
        * Dependency-free so that the runtime library (which is written in pure C) can be embedded in any application
      '';
      license = licenses.mit;
      maintainers = with maintainers; [Profpatsch];
    };
  }
