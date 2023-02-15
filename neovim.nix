{
  config = {
    perSystem = {pkgs, ...}: {
      neovim.plugins = {
        lir.enable = true;
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
            # foldclose = _: ''
            #   icons.get "chevron-right"
            # '';
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
          shortmess = _: ''
            vim.opt.shortmess + "a" + "F"
          '';
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
          # `luaexpr ''require("git-ignore").files()''`;
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
