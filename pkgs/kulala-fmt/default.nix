{buildGoModule, ...}: let
  sources = import ../../nix/sources.nix {};
in
  buildGoModule {
    name = "kulala-fmt";
    src = sources.kulala-fmt;
    vendorHash = "sha256-GazDEm/qv0nh8vYT+Tf0n4QDGHlcYtbMIj5rlZBvpKo=";
  }
