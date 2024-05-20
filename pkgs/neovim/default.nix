{
  fetchFromGitHub,
  fetchurl,
  gettext,
  inputs,
  lib,
  libiconv,
  libuv,
  libvterm-neovim,
  msgpack-c,
  neovim-unwrapped,
  rustPlatform,
  tree-sitter,
  ...
}: let
  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    inherit (inputs.neovim) rev;
    hash = inputs.neovim.narHash;
  };

  deps = lib.pipe "${src}/cmake.deps/deps.txt" [
    builtins.readFile
    (lib.splitString "\n")
    (map (builtins.match "([A-Z0-0_]+)_(URL|SHA256)[[:space:]]+([^[:space:]]+)[[:space:]]*"))
    (lib.remove null)
    (lib.flip builtins.foldl' {}
      (acc: matches: let
        name = lib.toLower (builtins.elemAt matches 0);
        key = lib.toLower (builtins.elemAt matches 1);
        value = lib.toLower (builtins.elemAt matches 2);
      in
        acc
        // {
          ${name} =
            acc.${name}
            or {}
            // {
              ${key} = value;
            };
        }))
    (builtins.mapAttrs (lib.const fetchurl))
  ];
in
  (neovim-unwrapped.override {
    gettext = gettext.overrideAttrs (_: {
      src = deps.gettext;
    });
    libiconv = libiconv.overrideAttrs (_: {
      src = deps.libiconv;
    });
    libuv = libuv.overrideAttrs (_: {
      src = deps.libuv;
    });
    libvterm-neovim = libvterm-neovim.overrideAttrs (_: {
      src = deps.libvterm;
    });
    msgpack-c = msgpack-c.overrideAttrs (_: {
      src = deps.msgpack;
    });
    tree-sitter = tree-sitter.override (_: {
      rustPlatform =
        rustPlatform
        // {
          buildRustPackage = args:
            rustPlatform.buildRustPackage (args
              // {
                src = deps.treesitter;
                cargoHash = "sha256-U2YXpNwtaSSEftswI0p0+npDJqOq5GqxEUlOPRlJGmQ=";
              });
        };
    });
    treesitter-parsers = let
      grammars = lib.filterAttrs (name: _: lib.hasPrefix "treesitter_" name) deps;
      parsers = lib.mapAttrs' (name: value: lib.nameValuePair (lib.removePrefix "treesitter_" name) {src = value;}) grammars;
    in
      parsers
      // {
        markdown = parsers.markdown // {location = "tree-sitter-markdown";};
        markdown-inline =
          parsers.markdown
          // {
            language = "markdown_inline";
            location = "tree-sitter-markdown-inline";
          };
      };
  })
  .overrideAttrs (oa: {
    version = "nightly";
    inherit src;
    preConfigure = ''
      ${oa.preConfigure}
      sed -i cmake.config/versiondef.h.in -e 's/@NVIM_VERSION_PRERELEASE@/-dev+${lib.substring 0 8 inputs.neovim.rev}/'
    '';
  })
