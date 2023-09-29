{
  fetchgit,
  lib,
  nix-prefetch-git,
  stdenv,
  symlinkJoin,
  tree-sitter,
  writeShellApplication,
}: let
  sources = import ../../nix/sources.nix {};
  src = sources.nvim-treesitter;

  # The grammars we care about:
  grammars = {
    bash = {
      owner = "tree-sitter";
    };
    c = {
      owner = "tree-sitter";
    };
    cmake = {
      owner = "uyha";
    };
    cpp = {
      owner = "tree-sitter";
      # NOTE: This patch provides support for several C++20 features, e.g. modules
      # override = {
      #   patches = [
      #     (fetchpatch {
      #       url = "https://github.com/tree-sitter/tree-sitter-cpp/pull/173.diff";
      #       hash = "sha256-HoL3cwgSrgqdFgTSbTKGdSHfycXJd60mwiUZssyaL8w=";
      #     })
      #   ];
      # };
    };
    dockerfile = {
      owner = "camdencheek";
    };
    fish = {
      owner = "ram02z";
    };
    go = {
      owner = "tree-sitter";
    };
    haskell = {
      owner = "tree-sitter";
    };
    html = {
      owner = "tree-sitter";
    };
    java = {
      owner = "tree-sitter";
    };
    javascript = {
      owner = "tree-sitter";
    };
    json = {
      owner = "tree-sitter";
    };
    json5 = {
      owner = "Joakker";
    };
    jsonc = rec {
      owner = "WhyNotHugo";
      url = "https://gitlab.com/${owner}/tree-sitter-jsonc";
    };
    jsonnet = {
      owner = "sourcegraph";
    };
    lua = {
      owner = "MunifTanjim";
    };
    make = {
      owner = "alemuller";
    };
    markdown = {
      owner = "MDeiml";
      sourceRoot = "tree-sitter-markdown";
    };
    markdown_inline = {
      owner = "MDeiml";
      repo = "tree-sitter-markdown";
      sourceRoot = "tree-sitter-markdown-inline";
    };
    nix = {
      owner = "cstrahan";
    };
    prisma = {
      owner = "victorhqc";
    };
    python = {
      owner = "tree-sitter";
    };
    query = {
      owner = "nvim-treesitter";
    };
    regex = {
      owner = "tree-sitter";
    };
    rust = {
      owner = "tree-sitter";
    };
    scheme = {
      owner = "6cdh";
    };
    sql = {
      owner = "DerekStride";
    };
    toml = {
      owner = "ikatyang";
    };
    tsx = {
      owner = "tree-sitter";
      repo = "tree-sitter-typescript";
      sourceRoot = "tsx";
    };
    typescript = {
      owner = "tree-sitter";
      sourceRoot = "typescript";
    };
    vim = {
      owner = "vigoux";
      repo = "tree-sitter-viml";
    };
    vimdoc = {
      owner = "neovim";
      inherit (sources.tree-sitter-vimdoc) rev;
    };
    xit = {
      owner = "synaptiko";
      rev = "7d79024";
    };
    yaml = {
      owner = "ikatyang";
    };
    zig = {
      owner = "maxxnino";
    };
  };

  lockfile = lib.importJSON "${src}/lockfile.json";

  grammars' =
    builtins.mapAttrs (name: value: rec {
      inherit (value) owner;
      repo =
        if value ? "repo"
        then value.repo
        else "tree-sitter-${name}";
      rev =
        if value ? "rev"
        then value.rev
        else lockfile."${name}".revision;
      url =
        if value ? "url"
        then value.url
        else "https://github.com/${owner}/${repo}";
    })
    grammars;

  foreachSh = attrs: f:
    lib.concatMapStringsSep "\n" f
    (lib.mapAttrsToList (k: v: {name = k;} // v) attrs);

  update-grammars = writeShellApplication {
    name = "update-grammars.sh";
    runtimeInputs = [nix-prefetch-git];
    text = ''
      out="''${1}/grammars"
      grammars="''${2:-all}"
      mkdir -p "$out"
      ${
        foreachSh grammars' ({
          name,
          url,
          rev,
          ...
        }: ''
          [ "''${grammars}" = "${name}" ] || [ "''${grammars}" = "all" ] && {
            echo "Updating treesitter parser for ${name}"
            ${nix-prefetch-git}/bin/nix-prefetch-git \
              --quiet \
              --no-deepClone \
              --url "${url}" \
              --rev "${rev}" > "$out"/${name}.json
          }
        '')
      }
    '';
  };

  treesitterGrammars = lib.mapAttrsToList (name: attrs:
    stdenv.mkDerivation ({
        name = "tree-sitter-${name}-grammar";
        src = let
          src' = lib.importJSON "${./.}/grammars/${name}.json";
        in
          fetchgit {
            inherit (src') url rev sha256 fetchLFS fetchSubmodules deepClone leaveDotGit;
          };

        buildInputs = [tree-sitter];

        CFLAGS = ["-Isrc" "-O2"];
        CXXFLAGS = ["-Isrc" "-O2"];

        dontConfigure = true;

        buildPhase = lib.concatStringsSep "\n" [
          "runHook preBuild"
          (
            if attrs ? "sourceRoot"
            then "cd ${attrs.sourceRoot}"
            else ""
          )
          ''
            if [[ -e "src/scanner.cc" ]]; then
                  $CXX -c "src/scanner.cc" -o scanner.o $CXXFLAGS
            elif [[ -e "src/scanner.c" ]]; then
              $CC -c "src/scanner.c" -o scanner.o $CFLAGS
            fi
            $CC -c "src/parser.c" -o parser.o $CFLAGS
            $CXX -shared -o parser *.o
            runHook postBuild
          ''
        ];

        installPhase = ''
          runHook preInstall
          mkdir -p $out/parser
          mv parser $out/parser/${name}.so
          runHook postInstall
        '';

        fixupPhase = lib.optionalString stdenv.isLinux ''
          runHook preFixup
          $STRIP $out/parser/${name}.so
          runHook postFixup
        '';
      }
      // attrs.override or {}))
  grammars;
in
  symlinkJoin {
    name = "nvim-treesitter";
    paths = [src] ++ treesitterGrammars;
    passthru = {inherit update-grammars;};
  }
