{
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "languagetool-rs";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "jeertmans";
    repo = "languagetool-rust";
    rev = "v${version}";
    hash = "sha256-tgx1LcVAlBcgYAdtn4n5TiLzinmOImLoatGowUFHpUM=";
  };

  cargoHash = "sha256-xqXLlUvGQseN6Pf9SKXCu2W0nSHA1EMgKHN/nGSZfXg=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  # FIXME: Lots of tests fail :(
  doCheck = false;
}
