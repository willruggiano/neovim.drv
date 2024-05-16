{
  fetchgit,
  lib,
  nix-prefetch-git,
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
    graphql = {
      owner = "bkegley";
    };
    haskell = {
      owner = "tree-sitter";
    };
    hcl = {
      owner = "tree-sitter-grammars";
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
    just = {
      owner = "IndianBoy42";
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
      out="./pkgs/nvim-treesitter/grammars"
      grammars="''${1:-all}"
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

  treesitterGrammars = lib.mapAttrsToList (language: attrs: let
    src' = lib.importJSON "${./.}/grammars/${language}.json";
  in
    tree-sitter.buildGrammar {
      inherit language;
      src = fetchgit {
        inherit (src') url rev sha256 fetchLFS fetchSubmodules deepClone leaveDotGit;
      };
      location = attrs.sourceRoot or null;
      version = lib.substring 0 8 src'.rev;

      installPhase = ''
        runHook preInstall
        mkdir $out
        mkdir -p $out/parser
        mv parser $out/parser/${language}.so
        if [[ -d queries ]]; then
          cp -r queries $out
        fi
        runHook postInstall
      '';
    })
  grammars;
in
  symlinkJoin {
    name = "nvim-treesitter";
    paths = [src] ++ treesitterGrammars;
    passthru = {inherit update-grammars;};
  }
