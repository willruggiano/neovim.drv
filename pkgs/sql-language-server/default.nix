{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
# FIXME: Uses yarn :sigh:
buildNpmPackage rec {
  pname = "sql-language-server";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "joe-re";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XPySDZwnAGSPrNXG6mzgnUy24BF9inaiKeJVPpjRnRE=";
  };

  npmDepsHash = "";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = ["--ignore-scripts"];

  meta = with lib; {
    description = "SQL Language Server";
    homepage = "https://github.com/joe-re/sql-language-server";
    license = licenses.gpl3Only;
  };
}
