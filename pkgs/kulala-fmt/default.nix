{
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule rec {
  name = "kulala-fmt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-fmt";
    rev = "v${version}";
    hash = "sha256-Fxxc8dJMiL7OVoovOt58vVaUloRjJX5hc8xSlzkwVc8=";
  };

  vendorHash = "sha256-uA29P6bcZNfxWsTfzsADBIqYgyfVX8dY8y70ZJKieas=";
}
