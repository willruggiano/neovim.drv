{
  buildLuarocksPackage,
  lua,
}: let
  sources = import ../nix/sources.nix;
in
  buildLuarocksPackage {
    pname = "fun";
    version = "scm-1";

    src = sources.luafun;
    knownRockspec = "${sources.luafun}/fun-scm-1.rockspec";

    nativeBuildInputs = [lua.pkgs.luarocksMoveDataFolder];
    propagatedBuildInputs = [lua];

    extraConfig = ''
      -- to create a flat hierarchy
      lua_modules_path = "lua"
    '';
  }
