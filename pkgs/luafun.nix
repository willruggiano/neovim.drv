{
  buildLuarocksPackage,
  fetchFromGitHub,
  fetchurl,
  lua,
}: let
  sources = import ../nix/sources.nix;
in
  buildLuarocksPackage {
    pname = "fun";
    version = "scm-1";

    src = sources.luafun;
    knownRockspec = "${sources.luafun}/fun-scm-1.rockspec";

    propagatedBuildInputs = [lua];
  }
