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
        # This would include the current directory in Neovim's runtimepath.
        # So we can put normal Vim stuff in this repo, e.g. after/plugin/*.lua
        src = ./.;

        # Tools to bake into the neovim environment.
        # These tools are *appended* to neovim's PATH variable,
        # such that if a tool is available locally (i.e. on the system PATH)
        # then it will be used instead. For example, you might want to provide
        # a default version of some lsp (rust-analyzer), but a project might
        # provide it's own version via direnv; neovim will use the latter,
        # project-specific version of the tool.
        paths = with pkgs; [
          # Docsets
          dasht
          (lib.optionals stdenv.isLinux elinks)
          # C++
          clang-tools
          cmake-language-server
          cppcheck
          # Json
          nodePackages.jsonlint
          # Lua
          luajitPackages.luacheck
          (lib.optionals stdenv.isLinux sumneko-lua-language-server)
          # Markdown
          marksman
          # Nix
          nil
          # Python
          nodePackages.pyright
          # Rust
          rust-analyzer
          # Sourcegraph
          inputs'.sg-nvim.packages.default
          # Typescript
          nodePackages.typescript-language-server
          # Zig
          zls
        ];

        # TODO: Should this just be lazy? Instead of neovim.lazy?
        lazy = {
          plugins = import ./plugins/spec.nix {
            inherit inputs' pkgs;
            neovim-utils = utils;
          };
          # plugins = import ./plugins {inherit lib pkgs utils;};
          # plugins = neovim-lib.importPluginsFromSpec ./plugins args;
        };
      };

      vim = {
        opt = rec {
          autoindent = true;
          belloff = "all";
          breakindent = true;
          cindent = true;
          clipboard = "unnamedplus";
          cmdheight = 1;
          conceallevel = 3;
          cursorline = true;
          equalalways = false;
          expandtab = true;
          exrc = true;
          fillchars = rec {
            eob = " ";
            fold = eob;
            foldopen = eob;
            foldsep = eob;
          };
          foldenable = true;
          foldlevel = 99;
          formatoptions = "cqrnj";
          grepprg = "${pkgs.ripgrep}/bin/ripgrep --vimgrep --smart-case --follow";
          hidden = true;
          hlsearch = true;
          ignorecase = true;
          inccommand = "split";
          incsearch = true;
          linebreak = true;
          listchars = {
            space = ".";
          };
          modelines = 1;
          mouse = "n";
          number = true;
          pumblend = 17;
          relativenumber = true;
          scrolloff = 10;
          secure = true;
          shada = ["!" "'1000" "<50" "s10" "h"];
          shiftwidth = tabstop;
          shortmess = _: ''vim.opt.shortmess + "a" + "F"'';
          showbreak = "   ";
          showcmd = true;
          showmatch = true;
          showmode = false;
          signcolumn = "yes";
          smartcase = true;
          softtabstop = tabstop;
          splitbelow = true;
          splitright = true;
          swapfile = false;
          tabstop = 4;
          termguicolors = true;
          timeoutlen = 500;
          updatetime = 1000;
          # TODO: It'd be nice to generate this, e.g.
          # `_: ''require("git-ignore").files()''`;
          # wildignore = ["*.o" "*~" "*.pyc" "*pycache*"];
          wildmode = ["longest" "full"];
          wildoptions = "pum";
          wrap = true;
        };

        g = {
          do_filetype_lua = true;
          loaded_2html_plugin = true;
          loaded_getscript = true;
          loaded_getscriptPlugin = true;
          loaded_gzip = true;
          loaded_logiPat = true;
          loaded_matchit = true;
          loaded_matchparen = true;
          loaded_netrw = true;
          loaded_netrwPlugin = true;
          loaded_netrwSettings = true;
          loaded_rrhelper = true;
          loaded_tar = true;
          loaded_tarPlugin = true;
          loaded_vimball = true;
          loaded_vimballPlugin = true;
          loaded_zip = true;
          loaded_zipPlugin = true;
          mapleader = ",";
        };
      };
    };
  };
}
