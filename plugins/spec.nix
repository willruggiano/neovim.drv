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
            event = "InsertEnter";
          };
        };
      };
      cmp-fuzzy-path = {
        src = sources.cmp-fuzzy-path;
        dependencies = {
          fuzzy_nvim = {
            src = sources."fuzzy.nvim";
          };
          inherit fzy-lua-native;
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
    };
  };

  colorizer = {
    src = sources."nvim-colorizer.lua";
    config = ./colorizer.lua;
  };

  Comment = {
    src = sources."Comment.nvim";
    config = ./comment.lua;
    dependencies = {
      inherit nvim-ts-context-commentstring;
    };
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
      nvim-dap-vscode-js = {
        src = sources.nvim-dap-vscode-js;
      };
      inherit rapidjson;
    };
    paths = with pkgs;
    with haskellPackages; [
      haskell-debug-adapter
    ];
  };

  dial = {
    src = sources."dial.nvim";
    config = ./dial.lua;
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

  fun = {
    package = let
      luafun = luajitPackages.callPackage ../pkgs/luafun.nix {};
    in
      neovim-utils.toLuarocksPlugin luafun;
  };

  fzy-lua-native = let
    package = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "fzy-lua-native";
      version = sources.fzy-lua-native.rev;
      src = sources.fzy-lua-native;
    };
  in {
    inherit package;
    init = pkgs.writeTextFile {
      name = "fzy-lua-native.lua";
      text = ''
        package.cpath = package.cpath .. ";" .. "${package}/static/?.so";
      '';
    };
  };

  gitsigns = {
    src = sources."gitsigns.nvim";
    config = ./gitsigns.lua;
  };

  graphql = {
    src = sources.vim-graphql;
  };

  indent_blankline = {
    src = sources."indent-blankline.nvim";
    config = ./indent-blankline.lua;
  };

  iron = {
    src = sources."iron.nvim";
    config = ./iron.lua;
  };

  leap = {
    src = sources."leap.nvim";
    config = ./leap.lua;
    dependencies = {
      flit = {
        src = sources."flit.nvim";
        config = true;
      };
      leap-ast = {
        src = sources."leap-ast.nvim";
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
      inherit nvim-web-devicons overseer plenary;
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
          pgformatter
          prettierd
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
      haskellPackages.cabal-fmt
      haskellPackages.haskell-language-server
      haskellPackages.ormolu
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

  nui = {
    src = sources."nui.nvim";
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
      inherit nvim-ts-context-commentstring;
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

  nvim-ts-context-commentstring = {
    src = sources.nvim-ts-context-commentstring;
  };

  nvim-web-devicons = {
    src = sources.nvim-web-devicons;
    config = ./devicons.lua;
    dependencies = {
      inherit nvim-nonicons;
    };
  };

  overseer = {
    src = sources."overseer.nvim";
    config = ./overseer.lua;
  };

  package-info = {
    src = sources."package-info.nvim";
    config = true;
    dependencies = {
      inherit nui;
    };
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

  regexplainer = {
    src = sources.nvim-regexplainer;
    config = true;
    dependencies = {
      inherit nui nvim-treesitter;
    };
  };

  # sg = let
  #   package = inputs'.sg-nvim.packages.default;
  # in {
  #   inherit package;
  #   init = pkgs.writeTextFile {
  #     name = "sg.lua";
  #     text = ''
  #       return function()
  #         package.cpath = package.cpath .. ";" .. "${package}/lib/?.so"
  #       end
  #     '';
  #   };
  # };

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
      smart-open = {
        src = sources."smart-open.nvim";
        dependencies = {
          sqlite = {
            src = sources."sqlite.lua";
            init = pkgs.writeTextFile {
              name = "sqlite.lua";
              text = ''
                return function()
                  vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"
                end
              '';
            };
          };
        };
        paths = with pkgs; [ripgrep];
      };
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
      telescope-manix = {
        src = sources.telescope-manix;
        paths = with pkgs; [manix];
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

  zk = {
    src = sources.zk-nvim;
    config = ./zk.lua;
    paths = [pkgs.zk];
  };
}
