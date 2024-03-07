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

  abolish = {
    src = sources.vim-abolish;
  };

  bqf = {
    src = sources.nvim-bqf;
    config = true;
    dependencies = {
      fzf = {
        src = sources.fzf;
      };
    };
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
      inherit sg;
      cmp-buffer = {
        src = sources.cmp-buffer;
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

  conform = {
    src = sources."conform.nvim";
    config = ./conform.lua;
    paths = with pkgs; [
      biome
      nodePackages.prettier # for markdown
      shellcheck
      shellharden
      shfmt
      sqlfluff
      stylua
    ];
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
        config = {
          adapters = [
            "node-terminal"
            "pwa-chrome"
            "pwa-extensionHost"
            "pwa-msedge"
            "pwa-node"
          ];
          debugger_cmd = [
            "node"
            "${inputs'.vscode-js-debug.packages.latest}/lib/node_modules/vscode-js-debug/dist/src/vsDebugServer.js"
          ];
        };
      };
      inherit rapidjson;
    };
    paths = with pkgs;
    with haskellPackages; [
      haskell-debug-adapter
    ];
  };

  dbee = let
    nvim-dbee = pkgs.callPackage ../pkgs/nvim-dbee.nix {};
  in {
    src = nvim-dbee;
    config = ./dbee.lua;
    paths = [nvim-dbee.dbee];
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

  flatten = {
    src = sources."flatten.nvim";
    config = {
      window = {
        open = "alternate";
      };
    };
    lazy = false;
    priority = 1001;
  };

  fun = {
    package = let
      luafun = luajitPackages.callPackage ../pkgs/luafun.nix {};
    in
      neovim-utils.toLuarocksPlugin luafun;
  };

  fzy-lua-native = let
    package = pkgs.vimUtils.buildVimPlugin {
      name = "fzy-lua-native";
      version = sources.fzy-lua-native.rev;
      src = sources.fzy-lua-native;
    };
  in {
    inherit package;
    init = pkgs.writeTextFile {
      name = "fzy-lua-native.lua";
      text = ''
        return function()
          package.cpath = package.cpath .. ";" .. "${package}/static/?.so";
        end
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

  hover = {
    src = sources."hover.nvim";
    config = ./hover.lua;
  };

  ibl = {
    src = sources."indent-blankline.nvim";
    config = ./indent-blankline.lua;
  };

  iron = {
    src = sources."iron.nvim";
    config = ./iron.lua;
  };

  jqx = {
    src = sources.nvim-jqx;
    ft = ["json" "yaml"];
    paths = with pkgs; [jq yq];
  };

  karen-yank = {
    src = sources."karen-yank.nvim";
    config = true;
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

  lsp-file-operations = {
    src = sources.nvim-lsp-file-operations;
    config = true;
    dependencies = {
      inherit neo-tree;
    };
  };

  lspconfig = {
    src = sources.nvim-lspconfig;
    config = ./lsp.lua;
    dependencies = {
      inherit conform fun lsp-file-operations lspkind sg;
      clangd_extensions = {
        src = sources."clangd_extensions.nvim";
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
        };
        paths = with pkgs; [
          # (pkgs.callPackage ../pkgs/languagetool-rs {})
          actionlint
          cppcheck
          luajitPackages.luacheck
          nodePackages.jsonlint
          shellcheck
          shellharden
          sqlfluff
          statix
        ];
      };
      rust-tools = {
        src = sources."rust-tools.nvim";
      };
      schemastore = {
        src = sources."SchemaStore.nvim";
      };
      typescript-tools = {
        src = sources."typescript-tools.nvim";
      };
    };
    paths = with pkgs; [
      alejandra # used by nil for formatting
      biome
      clang-tools
      cmake-language-server
      haskellPackages.cabal-fmt
      haskellPackages.haskell-language-server
      haskellPackages.ormolu
      inputs'.nil.packages.default
      inputs'.zls.packages.default
      marksman
      nodePackages.graphql-language-service-cli
      nodePackages.pyright
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      ruff-lsp
      rust-analyzer
      sumneko-lua-language-server
    ];
  };

  lspkind = {
    src = sources."lspkind.nvim";
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

  neo-tree = {
    src = sources."neo-tree.nvim";
    config = ./neo-tree.lua;
    dependencies = {
      inherit nvim-nonicons;
    };
  };

  nui = {
    src = sources."nui.nvim";
  };

  nvim-nonicons = {
    src = sources.nvim-nonicons;
  };

  nvim-notify = {
    src = sources.nvim-notify;
    config = ./notify.lua;
    lazy = false;
    priority = 1001;
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

  sg = let
    package = inputs'.sg-nvim.packages.sg-nvim;
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
    paths = [inputs'.sg-nvim.packages.default];
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

  twilight = {
    src = sources."twilight.nvim";
    config = true;
  };

  which-key = {
    src = sources."which-key.nvim";
    config = true;
  };

  wilder = {
    src = sources."wilder.nvim";
    config = ./wilder.lua;
    dependencies = {
      cpsm.package = pkgs.vimPlugins.cpsm;
    };
  };

  zen-mode = {
    src = sources."zen-mode.nvim";
    config = {
      plugins = {
        gitsigns.enabled = true;
        twilight.enabled = false;
      };
      window = {
        options = {
          number = false;
          relativenumber = false;
          signcolumn = "yes";
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
