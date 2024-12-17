{
  config,
  inputs',
  pkgs,
  ...
}: let
  sources = import ../nix/sources.nix {};
  inherit (pkgs) luajitPackages;
in rec {
  bombadil = {
    src = pkgs.callPackage ./bombadil {inherit (config.neovim) colorscheme;};
    config = ./bombadil.lua;
    lazy = false;
    priority = 1000;

    dependencies = {
      inherit lfs;
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

  # haven't written c++ in awhile... :sad sigh:
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
      inherit tailwind-tools;
      cmp-buffer.src = sources.cmp-buffer;
      cmp-cmdline.src = sources.cmp-cmdline;
      cmp-git = {
        src = sources.cmp-git;
        config = true;
      };
      cmp-nvim-lsp = {
        src = sources.cmp-nvim-lsp;
        dependencies = {
          inherit lspkind;
        };
      };
      cmp-nvim-lsp-document-symbol.src = sources.cmp-nvim-lsp-document-symbol;
      cmp-nvim-lsp-signature-help.src = sources.cmp-nvim-lsp-signature-help;
      cmp-path.src = sources.cmp-path;
    };
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
      # sql formatting is such ass :/
      # sleek # really fucks up plpgsql
      # sqlfluff # can be really slow
      python3.pkgs.sqlfmt # maybe?
      stylua
    ];
  };

  dap = {
    src = sources.nvim-dap;
    config = ./dap.lua;
    dependencies = {
      inherit rapidjson;
      dapui = {
        src = sources.nvim-dap-ui;
      };
      nio = {
        src = sources.nvim-nio;
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
    };
    paths = with pkgs.haskellPackages; [
      haskell-debug-adapter
    ];
  };

  dbee = let
    package = config.packages.nvim-dbee;
  in {
    inherit package;
    config = ./dbee.lua;
    paths = [package.dbee];
  };

  dial = {
    src = sources."dial.nvim";
    config = ./dial.lua;
  };

  dot-nvim = {
    src = sources.".nvim.nvim";
    dependencies = {inherit lfs;};
  };

  fastaction = {
    src = sources."fastaction.nvim";
    config = {
      dismiss_keys = ["<esc>" "j" "k"];
      popup.border = "single";
    };
  };

  fidget = {
    src = sources."fidget.nvim";
    config.text.spinner = "dots";
    config.sources = {
      null-ls = {
        ignore = true;
      };
    };
  };

  flatten = {
    src = sources."flatten.nvim";
    config.window.open = "alternate";
    lazy = false;
    priority = 1001;
  };

  fugitive = {
    src = sources.vim-fugitive;
    config = ./fugitive.lua;
  };

  fun = {
    package = config.packages.luafun;
  };

  ivy = {
    package = config.packages.ivy.vimPlugin;
    config = ./ivy.lua;
    cpath = "${config.packages.ivy}/lib/?.so";
  };

  gitsigns = {
    src = sources."gitsigns.nvim";
    config = ./gitsigns.lua;
  };

  grug-far = {
    src = sources."grug-far.nvim";
    config = ./grug.lua;
    paths = with pkgs; [ast-grep ripgrep];
  };

  ibl = {
    src = sources."indent-blankline.nvim";
    config = ./indent-blankline.lua;
  };

  iron = {
    src = sources."iron.nvim";
    config = ./iron.lua;
    paths = [pkgs.bun];
  };

  kulala = {
    src = sources."kulala.nvim";
    config = ./kulala.lua;
    dependencies = {
      inherit nvim-treesitter;
    };
    paths = [
      config.packages.kulala-fmt
    ];
  };

  leap = {
    src = sources."leap.nvim";
    config = ./leap.lua;
    dependencies = {
      flit = {
        src = sources."flit.nvim";
        config = true;
      };
      vim-repeat.src = sources."vim-repeat";
    };
  };

  lfs = let
    package = luajitPackages.luafilesystem;
  in {
    inherit package;
    cpath = "${package}/lib/lua/5.1/?.so";
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
      inherit conform fastaction fun lsp-file-operations lspkind tailwind-tools;
      clangd_extensions = {
        src = sources."clangd_extensions.nvim";
      };
      rust-tools = {
        src = sources."rust-tools.nvim";
      };
      schemastore = {
        src = sources."SchemaStore.nvim";
      };
      vtsls = {
        src = sources.nvim-vtsls;
        paths = [pkgs.vtsls];
      };
    };
    paths = with pkgs;
    with config.packages; [
      actionlint
      alejandra # used by nil for formatting
      basedpyright
      biome
      clang-tools
      cmake-language-server
      cppcheck
      efm-langserver
      haskellPackages.cabal-fmt
      haskellPackages.haskell-language-server
      haskellPackages.ormolu
      inputs'.nil.packages.default
      inputs'.zls.packages.default
      marksman
      nodePackages.bash-language-server
      nodePackages.graphql-language-service-cli
      nodePackages.typescript-language-server
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      ruff-lsp
      rust-analyzer
      tailwindcss-language-server
      sqlfluff
      # sqruff
      squawk
      statix
      sumneko-lua-language-server
    ];
  };

  lspkind = {
    src = sources."lspkind.nvim";
  };

  lualine = {
    src = sources."lualine.nvim";
    config = ./lualine.lua;
  };

  lyaml = {
    package = pkgs.neovimUtils.buildNeovimPlugin {
      inherit (luajitPackages.lyaml) pname;
    };
  };

  markdown = {
    src = sources.vim-markdown;
    config = ./markdown.lua;
  };

  matchup = {
    src = sources.vim-matchup;
    init = ''
      function()
        vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
      end
    '';
    config = ''
      function()
        require("flavours").highlight.MatchParen = "LspReferenceText"
      end
    '';
  };

  neo-tree = {
    src = sources."neo-tree.nvim";
    config = ./neo-tree.lua;
    dependencies = {
      inherit nvim-web-devicons plenary;
      nui.src = sources."nui.nvim";
    };
  };

  nvim-surround = {
    src = sources.nvim-surround;
    config = true;
  };

  nvim-treesitter = {
    package = config.packages.nvim-treesitter;
    config = ./treesitter.lua;
    dependencies = {
      inherit matchup nvim-ts-context-commentstring;
      nvim-treesitter-textobjects = {
        src = sources.nvim-treesitter-textobjects;
      };
    };
  };

  nvim-ts-context-commentstring = {
    src = sources.nvim-ts-context-commentstring;
    config = {
      enable_autocmd = false;
    };
  };

  nvim-web-devicons = {
    src = sources.nvim-web-devicons;
    config = ./devicons.lua;
    dependencies = {
      nvim-nonicons.src = sources.nvim-nonicons;
    };
  };

  overseer = {
    src = sources."overseer.nvim";
    config = ./overseer.lua;
  };

  plenary = {
    src = sources."plenary.nvim";
  };

  quicker = {
    src = sources."quicker.nvim";
    config = ./quicker.lua;
  };

  rapidjson = let
    package = luajitPackages.rapidjson;
  in {
    inherit package;
    cpath = "${package}/lib/lua/5.1/?.so";
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

  tailwind-tools = {
    src = sources."tailwind-tools.nvim";
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
            init = ''
              function()
                vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"
              end
            '';
          };
        };
        paths = with pkgs; [ripgrep];
      };
      telescope-docsets = {
        src = sources."telescope-docsets.nvim";
        paths = with pkgs; [dasht elinks];
      };
      telescope-fzf-native = {
        package = pkgs.vimUtils.buildVimPlugin {
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
      telescope-undo = {
        src = sources."telescope-undo.nvim";
        dependencies = {
          inherit plenary;
        };
        paths = with pkgs; [delta];
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
    config = {
      icons.rules = false;
      notify = false;
    };
  };

  # Gonna give cmp-cmdline another try lol
  # wilder = {
  #   src = sources."wilder.nvim";
  #   config = ./wilder.lua;
  #   dependencies = {
  #     cpsm.package = pkgs.vimPlugins.cpsm;
  #     fzy-lua-native = let
  #       package = pkgs.vimUtils.buildVimPlugin {
  #         name = "fzy-lua-native";
  #         version = sources.fzy-lua-native.rev;
  #         src = sources.fzy-lua-native;
  #       };
  #     in {
  #       inherit package;
  #       cpath = "${package}/static/?.so";
  #     };
  #   };
  # };

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
}
