{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "vtsls";
  version = "0.2.5";
  src = fetchFromGitHub {
    owner = "yioneko";
    repo = pname;
    rev = "server-v${version}";
    hash = "sha256-rbvM/2U88Qd6cHbUrQMNUOKebY15IQsBHG7C0yeeJyA=";
  };
  npmDepsHash = "";
  npmPackFlags = ["--ignore-scripts"];
  meta = {
    description = "LSP wrapper for typescript extension of vscode";
    homepage = "https://github.com/yioneko/vtsls";
    license = lib.licenses.mit;
  };
}
