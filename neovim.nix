{
  config = {
    perSystem = {
      lib,
      pkgs,
      neovim-lib,
      inputs',
      ...
    }: let
      inherit (inputs'.neovim-nix.packages) utils;
    in {
      neovim = {
        # Environment variables to bake into the neovim environment.
        # If an environment variable is already defined, the existing definition will take precedence.
        env = {
          SRC_ENDPOINT = "https://sourcegraph.com";
          # https://github.com/wez/wezterm/issues/415#issuecomment-755849623
          TERM = "wezterm";
        };

        package = inputs'.neovim.packages.default.override {
          libvterm-neovim = pkgs.libvterm-neovim.overrideAttrs rec {
            version = "0.3.3";
            src = pkgs.fetchurl {
              url = "https://github.com/neovim/libvterm/archive/v${version}.tar.gz";
              hash = "sha256-C6vjq0LDVJJdre3pDTUvBUqpxK5oQuqAOiDJdB4XLlY=";
            };
          };
        };

        # Tools to bake into the neovim environment.
        # These tools are *appended* to neovim's PATH variable,
        # such that if a tool is available locally (i.e. on the system PATH)
        # then it will be used instead. For example, you might want to provide
        # a default version of some tool (e.g. rust-analyzer), but a project might
        # provide it's own version via direnv; neovim will use the latter,
        # project-specific version of the tool.
        paths = with pkgs; [
          git
          lazygit
          nodejs
        ];

        lazy = {
          settings = {
            performance.rtp = {
              reset = true;
              disabled_plugins = [
                "gzip"
                "matchit"
                "matchparen"
                "netrwPlugin"
                "shada"
                "spellfile"
                "tarPlugin"
                "tohtml"
                "zipPlugin"
              ];
            };
          };
          plugins = import ./plugins/spec.nix {
            inherit inputs' pkgs;
            neovim-utils = utils;
          };
          # plugins = import ./plugins {inherit lib pkgs utils;};
          # plugins = neovim-lib.importPluginsFromSpec ./plugins args;
        };
      };
    };
  };
}
