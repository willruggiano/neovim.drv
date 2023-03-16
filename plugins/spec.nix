{
  inputs',
  neovim-utils,
  pkgs,
  ...
}: let
  sources = import ../nix/sources.nix {};
  inherit (pkgs) luajitPackages;
in {
  # NOTE: This contains our colorscheme!
  flavours = {
    config = ./flavours.lua;
    src = ./flavours;
    lazy = false;
    priority = 1000;
  };

  bqf = {
    config = true;
    src = sources.nvim-bqf;
  };

  bufdelete = {
    src = sources."bufdelete.nvim";
  };

  cargo-expand = {
    ft = "rust";
    src = sources."cargo-expand.nvim";
  };

  clang-format = {
    dependencies = [
      {
        name = "clangd_extensions";
        src = sources."clangd_extensions.nvim";
      }
      "lyaml"
    ];
    ft = ["c" "cpp"];
    src = sources."clang-format.nvim";
  };

  close-buffers = {
    src = sources."close-buffers.nvim";
  };

  cmp = {
    src = sources.nvim-cmp;
    config = ./cmp.lua;
    dependencies = [
      {
        name = "cmp-buffer";
        src = sources.cmp-buffer;
      }
      {
        name = "cmp-fuzzy-path";
        src = sources.cmp-fuzzy-path;
      }
      {
        name = "fuzzy_nvim";
        src = sources."fuzzy.nvim";
      }
      {
        name = "fzy-lua-native";
        src = sources.fzy-lua-native;
      }
      {
        name = "cmp-git";
        src = sources.cmp-git;
      }
      "lspkind"
      {
        name = "cmp-nvim-lsp";
        src = sources.cmp-nvim-lsp;
      }
      {
        name = "cmp-nvim-lsp-signature-help";
        src = sources.cmp-nvim-lsp-signature-help;
      }
      {
        name = "cmp-path";
        src = sources.cmp-path;
      }
      {
        name = "cmp-snippy";
        src = sources.cmp-snippy;
      }
      {
        name = "snippy";
        src = sources.nvim-snippy;
      }
      {
        name = "cmp-under-comparator";
        src = sources.cmp-under-comparator;
      }
      {
        name = "neogen";
        src = sources.neogen;
      }
    ];
  };

  colorizer = {
    src = sources."nvim-colorizer.lua";
    config = true;
  };

  cpsm = {
    package = neovim-utils.mkPlugin {
      name = "cpsm";
      src = sources.cpsm;
      nativeBuildInputs = [pkgs.cmake];
      buildInputs = with pkgs; [boost ncurses python3];
      buildPhase = ''
        cmake -S . -B build -DPY3:BOOL=ON
        cmake --build build --target install
      '';
    };
  };

  firvish = {
    src = sources."firvish.nvim";
    config = ./firvish.lua;
    dependencies = [
      {
        name = "buffers-firvish";
        src = sources."buffers.firvish";
      }
      {
        name = "git-firvish";
        src = sources."git.firvish";
      }
      {
        name = "firvish-history";
        src = sources."history.firvish";
      }
      {
        name = "jobs-firvish";
        src = sources."jobs.firvish";
      }
    ];
  };

  fun = {
    package = let
      luafun = luajitPackages.callPackage ../pkgs/luafun.nix {};
    in
      neovim-utils.toLuarocksPlugin luafun;
  };

  indent_blankline = {
    config = true;
    src = sources."indent-blankline.nvim";
  };

  lfs = {
    package = neovim-utils.toLuarocksPlugin luajitPackages.luafilesystem;
  };

  lir = {
    config = ./lir.lua;
    dependencies = [
      "firvish"
      "nvim-web-devicons"
      "plenary"
      {
        name = "git_status";
        src = sources."lir-git-status.nvim";
      }
    ];
    src = sources."lir.nvim";
  };

  lspconfig = {
    config = ./lsp.lua;
    dependencies = [
      "lspkind"
      "fun"
      {
        name = "neodev";
        src = sources."neodev.nvim";
      }
      {
        name = "null-ls";
        src = sources."null-ls.nvim";
      }
    ];
    src = sources.nvim-lspconfig;
  };

  lspkind = {
    src = sources.lspkind-nvim;
  };

  lyaml = {
    package = neovim-utils.toLuarocksPlugin luajitPackages.lyaml;
  };

  nvim-autopairs = {
    config = true;
    src = sources.nvim-autopairs;
  };

  nvim-nonicons = {
    src = sources.nvim-nonicons;
  };

  nvim-web-devicons = {
    config = ./devicons.lua;
    dependencies = [
      "nvim-nonicons"
    ];
    src = sources.nvim-web-devicons;
  };

  plenary = {
    src = sources."plenary.nvim";
  };

  sg = {
    package = inputs'.sg-nvim.packages.default;
  };

  which-key = {
    src = sources."which-key.nvim";
    config = true;
  };
}
