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
        };

        package = inputs'.neovim.packages.default.override {
          tree-sitter = pkgs.callPackage ./pkgs/tree-sitter.nix {};
        };

        # Tools to bake into the neovim environment.
        # These tools are *appended* to neovim's PATH variable,
        # such that if a tool is available locally (i.e. on the system PATH)
        # then it will be used instead. For example, you might want to provide
        # a default version of some tool (e.g. rust-analyzer), but a project might
        # provide it's own version via direnv; neovim will use the latter,
        # project-specific version of the tool.
        paths = with pkgs; [
          fswatch
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
