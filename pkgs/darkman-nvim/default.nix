{
  buildEnv,
  buildGoModule,
  vimUtils,
  ...
}: let
  sources = import ../../nix/sources.nix {};
  bin = buildGoModule {
    name = "darkman";
    src = sources."darkman.nvim";
    vendorHash = "sha256-HpyKzvKVN9hVRxxca4sdWRo91H32Ha9gxitr7Qg5MY8=";
  };
  vimPlugin = vimUtils.buildVimPlugin {
    name = "darkman-nvim";
    src = sources."darkman.nvim";
    nvimRequireCheck = "darkman";
    propagatedBuildInputs = [bin];
    passthru.darkman = bin;
  };
in
  buildEnv {
    name = "darkman.nvim";
    paths = [vimPlugin bin];
  }
