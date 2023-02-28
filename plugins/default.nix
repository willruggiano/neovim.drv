{
  lib,
  pkgs,
  utils,
  ...
}: let
  sources = import ../nix/sources.nix {};
  rocks = pkgs.luajitPackages;

  mkPlugin = name: attrs:
    utils.mkPlugin ({
        inherit name;
        src = sources."${name}";
      }
      // attrs);
  mkPlugin' = name: mkPlugin name {};

  # TODO: This could be automated.
  # e.g. `utils.importNivSources ...` or something
  autopairs-nvim = mkPlugin' "nvim-autopairs";
  blankline-nvim = mkPlugin' "indent-blankline.nvim";
  bqf-nvim = mkPlugin' "nvim-bqf";
  bufdelete-nvim = mkPlugin' "bufdelete.nvim";
  cargo-expand-nvim = mkPlugin' "cargo-expand.nvim";
  clang-format-nvim = mkPlugin' "clang-format.nvim";
  close-buffer-nvim = mkPlugin' "close-buffers.nvim";
  devicons-nvim = mkPlugin' "nvim-web-devicons";
  lir-nvim = mkPlugin' "lir.nvim";
  nonicons-nvim = mkPlugin' "nvim-nonicons";
  plenary-nvim = mkPlugin' "plenary.nvim";
in [
  # Really we don't even need this. We can handle the local case with Nix.
  # {
  #   name = "firvish.nvim";
  #   config = true;
  #   dev = true;
  # }
  {
    name = "nvim-autopairs";
    package = autopairs-nvim;
    config = true;
  }
  {
    name = "indent_blankline";
    package = blankline-nvim;
    config = true;
  }
  {
    name = "bqf";
    package = bqf-nvim;
    config = true;
  }
  # TODO: For some reason, lazy tries to call `setup()` on this one?
  # {
  #   package = bufdelete-nvim;
  # }
  {
    package = cargo-expand-nvim;
    ft = "rust";
  }
  {
    package = clang-format-nvim;
    dependencies = [
      rocks.lyaml
    ];
    ft = ["c" "cpp"];
  }
  {
    package = close-buffer-nvim;
  }
  {
    package = devicons-nvim;
    dependencies = [
      nonicons-nvim
    ];
    config = ./devicons.lua;
  }
  {
    name = "lir";
    package = lir-nvim;
    dependencies = [
      devicons-nvim
      plenary-nvim
    ];
    config = true;
    opts = {
      devicons = {
        enable = true;
      };
    };
  }
]
