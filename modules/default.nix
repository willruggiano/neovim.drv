{
  imports = [
    ./colorscheme
  ];

  perSystem = {
    config,
    lib,
    pkgs,
    inputs',
    ...
  } @ args: {
    neovim = {
      package = config.packages.neovim-nightly;

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
        xdg-utils # gx
      ];

      # Doesn't quite work :( since it uses flake-root under the hood, with the
      # implication that I can only open neovim in a directory with a flake.nix
      # source = [(lib.getExe config.agenix-shell.installationScript)];

      lazy = {
        settings = {
          performance.rtp = {
            reset = true;
            disabled_plugins = [
              "gzip"
              "matchit"
              "matchparen"
              # "netrwPlugin"
              "shada"
              "spellfile"
              "tarPlugin"
              "tohtml"
              "zipPlugin"
            ];
          };
          pkg.enabled = false;
        };
        plugins = import ../plugins/spec.nix args;
      };
    };
  };
}
