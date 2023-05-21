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
      inherit lfs lua-utf8;
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
    paths = [pkgs.cargo-expand];
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
      cmp_copilot = {
        src = sources.copilot-cmp;
        config = true;
        dependencies = {
          copilot = {
            src = sources."copilot.lua";
            config = {
              suggestion.enabled = false;
              panel.enabled = false;
            };
          };
        };
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
    config = ./colorizer.lua;
  };

  Comment = {
    src = sources."Comment.nvim";
    config = ./comment.lua;
  };

  dadbod = {
    src = sources.vim-dadbod;
    config = ./dadbod.lua;
    dependencies = {
      inherit cmp;
      dadbod-completion = {
        src = sources.vim-dadbod-completion;
      };
      dadbod-ui = {
        src = sources.vim-dadbod-ui;
      };
    };
  };

  dap = {
    src = sources.nvim-dap;
    config = ./dap.lua;
    dependencies = {
      dapui = {
        src = sources.nvim-dap-ui;
      };
      nvim-dap-virtual-text = {
        src = sources.nvim-dap-virtual-text;
        config = true;
      };
      inherit rapidjson;
    };
  };

  dial = {
    src = sources."dial.nvim";
    config = ./dial.lua;
  };

  diffview = {
    src = sources."diffview.nvim";
    config = ./diffview.lua;
    dependencies = {
      inherit nvim-nonicons nvim-web-devicons plenary;
    };
  };

  dot-nvim = {
    src = sources.".nvim.nvim";
  };

  fidget = {
    src = sources."fidget.nvim";
    config = {
      text = {
        spinner = "dots";
      };
      sources = {
        null-ls = {
          ignore = true;
        };
      };
    };
  };

  firvish = {
    src = sources."firvish.nvim";
    config = ./firvish.lua;
    dependencies = {
      buffers-firvish = {
        src = sources."buffers.firvish";
      };
      # git-firvish = {
      #   src = sources."git.firvish";
      # };
      # firvish-history = {
      #   src = sources."history.firvish";
      # };
      # jobs-firvish = {
      #   src = sources."jobs.firvish";
      # };
      # netrw-firvish = {
      #   # src = sources."netrw.firvish";
      #   src = /home/bombadil/dev/netrw.firvish;
      # };
    };
  };

  fun = {
    package = let
      luafun = luajitPackages.callPackage ../pkgs/luafun.nix {};
    in
      neovim-utils.toLuarocksPlugin luafun;
  };

  gh = {
    src = sources."gh.nvim";
    config = ./github.lua;
    dependencies = {
      inherit telescope which-key;
      gh-actions = {
        src = sources."gh-actions.nvim";
        config = true;
        dependencies = {
          inherit plenary nui;
        };
      };
      litee = {
        src = sources."litee.nvim";
      };
      telescope-github = {
        src = sources."telescope-github.nvim";
      };
    };
    paths = [pkgs.gh];
  };

  git-worktree = {
    src = sources."git-worktree.nvim";
    config = ./git-worktree.lua;
    dependencies = {
      inherit telescope which-key;
    };
  };

  gitsigns = {
    src = sources."gitsigns.nvim";
    config = ./gitsigns.lua;
  };

  graphql = {
    src = sources.vim-graphql;
  };

  harpoon = {
    src = sources.harpoon;
    config = ./harpoon.lua;
  };

  indent_blankline = {
    src = sources."indent-blankline.nvim";
    config = ./indent-blankline.lua;
  };

  leap = {
    src = sources."leap.nvim";
    config = ./leap.lua;
    dependencies = {
      flit = {
        src = sources."flit.nvim";
        config = true;
      };
      leap-spooky = {
        src = sources."leap-spooky.nvim";
        config = true;
      };
    };
  };

  lfs = let
    package = luajitPackages.luafilesystem;
  in {
    inherit package;
    init = pkgs.writeTextFile {
      name = "lfs.lua";
      text = ''
        return function()
          package.cpath = package.cpath .. ";" .. "${package}/lib/lua/5.1/?.so"
        end
      '';
    };
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
    src = sources.nvim-lspconfig;
    config = ./lsp.lua;
    dependencies = {
      inherit fun lspkind;
      clangd_extensions = {
        src = sources."clangd_extensions.nvim";
      };
      neodev = {
        src = sources."neodev.nvim";
      };
      null-ls = {
        src = sources."null-ls.nvim";
        dependencies = {
          crates = {
            src = sources."crates.nvim";
            config = {
              null_ls = {
                enabled = true;
                name = "crates";
              };
            };
            paths = [pkgs.cargo];
          };
          refactoring = {
            src = sources."refactoring.nvim";
          };
        };
        paths = with pkgs; [
          (pkgs.callPackage ../pkgs/languagetool-rs {})
          actionlint
          alejandra
          cmake-format
          cppcheck
          luajitPackages.luacheck
          nodePackages.eslint_d
          nodePackages.jsonlint
          nodePackages.prettier
          # nodePackages.pretterd
          nodePackages.prisma
          pgformatter
          rustfmt
          shellcheck
          shellharden
          shfmt
          sqlfluff
          statix
          stylua
          yapf
        ];
      };
      schemastore = {
        src = sources."SchemaStore.nvim";
      };
    };
    paths = with pkgs; [
      clang-tools
      cmake-language-server
      inputs'.nil.packages.default
      inputs'.sg-nvim.packages.default
      inputs'.zls.packages.default
      marksman
      nodePackages.graphql-language-service-cli
      nodePackages.pyright
      nodePackages.typescript-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      rust-analyzer
      sumneko-lua-language-server
    ];
  };

  lspkind = {
    src = sources.lspkind-nvim;
  };

  lualine = {
    src = sources."lualine.nvim";
    config = ./lualine.lua;
    dependencies = {
      # inherit lir;
    };
  };

  lua-utf8 = let
    package = luajitPackages.luautf8;
  in {
    inherit package;
    init = pkgs.writeTextFile {
      name = "lfs.lua";
      text = ''
        return function()
          package.cpath = package.cpath .. ";" .. "${package}/lib/lua/5.1/?.so"
        end
      '';
    };
  };

  lyaml = {
    package = neovim-utils.toLuarocksPlugin luajitPackages.lyaml;
  };

  markdown = {
    src = sources.vim-markdown;
    config = ./markdown.lua;
  };

  marks = {
    src = sources."marks.nvim";
    config = ./marks.lua;
  };

  neogen = {
    src = sources.neogen;
    config = ./neogen.lua;
  };

  neogit = {
    src = sources.neogit;
    config = ./neogit.lua;
  };

  nui = {
    src = sources."nui.nvim";
  };

  nvim-cheat = {
    src = sources."nvim-cheat.sh";
    config = ./cheat.lua;
    dependencies = {
      popfix.src = sources.popfix;
    };
  };

  nvim-nonicons = {
    src = sources.nvim-nonicons;
  };

  nvim-surround = {
    src = sources.nvim-surround;
    config = true;
  };

  nvim-treesitter = {
    package = pkgs.callPackage ../pkgs/nvim-treesitter {};
    config = ./treesitter.lua;
    dependencies = {
      nvim-treesitter-playground = {
        src = sources.playground;
      };
      nvim-treesitter-refactor = {
        src = sources.nvim-treesitter-refactor;
      };
      nvim-treesitter-textobjects = {
        src = sources.nvim-treesitter-textobjects;
      };
      treesitter-unit = {
        src = sources.treesitter-unit;
      };
    };
  };

  nvim-web-devicons = {
    src = sources.nvim-web-devicons;
    config = ./devicons.lua;
    dependencies = {
      inherit nvim-nonicons;
    };
  };

  package-info = {
    src = sources."package-info.nvim";
    config = true;
    dependencies = {
      inherit nui;
    };
  };

  persisted = {
    src = sources."persisted.nvim";
    config = ./persisted.lua;
  };

  plenary = {
    src = sources."plenary.nvim";
  };

  pqf = {
    src = sources.nvim-pqf;
    config = ./pqf.lua;
  };

  rainbow-csv = {
    src = sources.rainbow_csv;
  };

  rapidjson = let
    package = luajitPackages.rapidjson;
  in {
    inherit package;
    init = pkgs.writeTextFile {
      name = "rapidjson.lua";
      text = ''
        return function()
          package.cpath = package.cpath .. ";" .. "${package}/lib/lua/5.1/?.so"
        end
      '';
    };
  };

  sg = let
    package = inputs'.sg-nvim.packages.default;
  in {
    inherit package;
    init = pkgs.writeTextFile {
      name = "sg.lua";
      text = ''
        return function()
          package.cpath = package.cpath .. ";" .. "${package}/lib/?.so"
        end
      '';
    };
  };

  statuscol = {
    src = sources."statuscol.nvim";
    config = {
      setopt = true;
    };
  };

  tabout = {
    src = sources."tabout.nvim";
    config = ./tabout.lua;
  };

  telescope = {
    src = sources."telescope.nvim";
    config = ./telescope.lua;
    dependencies = {
      inherit nvim-web-devicons;
      telescope-docsets = {
        src = sources."telescope-docsets.nvim";
        paths = with pkgs; [dasht elinks];
      };
      telescope-fzf-native = {
        package = neovim-utils.mkPlugin {
          name = "telescope-fzf-native";
          src = sources."telescope-fzf-native.nvim";
          buildPhase = "";
        };
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

  twilight = {
    src = sources."twilight.nvim";
    config = true;
  };

  undotree = {
    src = sources.undotree;
    config = ./undotree.lua;
  };

  which-key = {
    src = sources."which-key.nvim";
    config = true;
  };

  wilder = {
    src = sources."wilder.nvim";
    config = ./wilder.lua;
    dependencies = {
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
    };
  };

  xit = {
    src = sources."xit.nvim";
    config = true;
  };

  zk = {
    src = sources.zk-nvim;
    config = ./zk.lua;
    paths = [pkgs.zk];
  };
}
