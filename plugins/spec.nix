{
  inputs',
  neovim-utils,
  pkgs,
  ...
}: let
  sources = import ../nix/sources.nix {};
  inherit (pkgs) luajitPackages;
in rec {
  bombadil = {
    src = ./bombadil;
    config = ./bombadil.lua;
    lazy = false;
    priority = 1000;

    dependencies = {
      inherit lfs;
    };
  };

  bqf = {
    src = sources.nvim-bqf;
    config = true;
  };

  bufdelete = {
    src = sources."bufdelete.nvim";
  };

  cargo-expand = {
    src = sources."cargo-expand.nvim";
    ft = "rust";
  };

  clang-format = {
    src = sources."clang-format.nvim";
    dependencies = {
      inherit lyaml;
    };
    ft = ["c" "cpp"];
  };

  close-buffers = {
    src = sources."close-buffers.nvim";
  };

  cmp = {
    src = sources.nvim-cmp;
    config = ./cmp.lua;
    dependencies = {
      cmp-buffer = {
        src = sources.cmp-buffer;
      };
      cmp-fuzzy-path = {
        src = sources.cmp-fuzzy-path;
        dependencies = {
          fuzzy_nvim = {
            src = sources."fuzzy.nvim";
          };
          fzy-lua-native = {
            src = sources.fzy-lua-native;
          };
        };
      };
      cmp-git = {
        src = sources.cmp-git;
      };
      cmp-nvim-lsp = {
        src = sources.cmp-nvim-lsp;
        dependencies = {
          inherit lspkind;
        };
      };
      cmp-nvim-lsp-signature-help = {
        src = sources.cmp-nvim-lsp-signature-help;
      };
      cmp-path = {
        src = sources.cmp-path;
      };
      cmp-snippy = {
        src = sources.cmp-snippy;
        dependencies = {
          snippy = {
            src = sources.nvim-snippy;
          };
        };
      };
      cmp-under-comparator = {
        src = sources.cmp-under-comparator;
      };
      inherit neogen;
    };
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
    dependencies = {
      buffers-firvish = {
        src = sources."buffers.firvish";
      };
      git-firvish = {
        src = sources."git.firvish";
      };
      firvish-history = {
        src = sources."history.firvish";
      };
      jobs-firvish = {
        src = sources."jobs.firvish";
      };
    };
  };

  fun = {
    package = let
      luafun = luajitPackages.callPackage ../pkgs/luafun.nix {};
    in
      neovim-utils.toLuarocksPlugin luafun;
  };

  git-worktree = {
    src = sources."git-worktree.nvim";
    config = ./git-worktree.lua;
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
    dependencies = {
      inherit firvish nvim-web-devicons plenary;
      git_status = {
        src = sources."lir-git-status.nvim";
      };
    };
    src = sources."lir.nvim";
  };

  lspconfig = {
    config = ./lsp.lua;
    dependencies = {
      clangd_extensions = {
        src = sources."clangd_extensions.nvim";
      };
      inherit fun lspkind;
      neodev = {
        src = sources."neodev.nvim";
      };
      null-ls = {
        src = sources."null-ls.nvim";
      };
    };
    src = sources.nvim-lspconfig;
  };

  lspkind = {
    src = sources.lspkind-nvim;
  };

  lualine = {
    src = sources."lualine.nvim";
    config = ./lualine.lua;
    dependencies = {
      inherit lir;
    };
  };

  lyaml = {
    package = neovim-utils.toLuarocksPlugin luajitPackages.lyaml;
  };

  neogen = {
    src = sources.neogen;
  };

  nvim-autopairs = {
    config = true;
    src = sources.nvim-autopairs;
  };

  nvim-web-devicons = {
    src = sources.nvim-web-devicons;
    config = ./devicons.lua;
    dependencies = {
      nvim-nonicons = {
        src = sources.nvim-nonicons;
      };
    };
  };

  plenary = {
    src = sources."plenary.nvim";
  };

  sg = {
    package = inputs'.sg-nvim.packages.default;
  };

  telescope = {
    src = sources."telescope.nvim";
    config = ./telescope.lua;
    dependencies = {
      inherit git-worktree nvim-web-devicons;
      telescope-arecibo = {
        src = sources."telescope-arecibo.nvim";
      };
      telescope-docsets = {
        src = sources."telescope-docsets.nvim";
      };
      telescope-dotfiles = {
        src = ./telescope-dotfiles;
      };
      telescope-fzf-native = {
        package = neovim-utils.mkPlugin {
          name = "telescope-fzf-native";
          src = sources."telescope-fzf-native.nvim";
          buildPhase = "";
        };
      };
      telescope-github = {
        src = sources."telescope-github.nvim";
      };
      telescope-project = {
        src = sources."telescope-project.nvim";
      };
      telescope-symbols = {
        src = sources."telescope-symbols.nvim";
      };
      telescope-ui-select = {
        src = sources."telescope-ui-select.nvim";
      };
    };
  };

  toggleterm = {
    src = sources."toggleterm.nvim";
    config = ./toggleterm.lua;
  };

  which-key = {
    src = sources."which-key.nvim";
    config = true;
  };
}
