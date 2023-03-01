{
  buildLuarocksPackage,
  fetchFromGitHub,
  fetchurl,
  lua,
}:
buildLuarocksPackage rec {
  pname = "fun";
  version = "scm-1";

  knownRockspec =
    (fetchurl {
      url = "mirror://luarocks/fun-${version}.rockspec";
      hash = "sha256-35RcuCYBf5nSO65qBYLYNWmRCaCbFqQdXrk3wBy/lQU=";
    })
    .out;

  src = fetchFromGitHub {
    owner = "luafun";
    repo = "luafun";
    rev = "cb6a7e25d4b55d9578fd371d1474b00e47bd29f3";
    hash = "sha256-lqWTPn1HPQxhfkUFvEUCbS05IkkroaykgYehJqQ0+lw=";
  };

  propagatedBuildInputs = [lua];
}
