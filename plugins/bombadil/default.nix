{
  buildEnv,
  lib,
  ...
}:
buildEnv {
  name = "vimplugin-bombadil";
  paths = [
    (lib.cleanSourceWith {
      src = ./.;
      filter = name: _: !(lib.hasSuffix ".nix" name);
    })
  ];
}
