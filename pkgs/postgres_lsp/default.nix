{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  ...
}:
stdenv.mkDerivation rec {
  pname = "postgrestools";
  version = "0.3.1";
  src = fetchurl {
    url = "https://github.com/supabase-community/postgres-language-server/releases/download/${version}/postgrestools_x86_64-unknown-linux-gnu";
    hash = "sha256-ludcF07fi1OOctoqFhjGRa0dvAVhE4G+MyuQFk/5aEE=";
  };
  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [stdenv.cc.cc.libgcc];
  dontUnpack = true;
  installPhase = ''
    install -D -m755 $src $out/bin/postgrestools
  '';
}
