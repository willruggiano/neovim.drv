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
        # Tools to bake into the neovim environment.
        # These tools are *appended* to neovim's PATH variable,
        # such that if a tool is available locally (i.e. on the system PATH)
        # then it will be used instead. For example, you might want to provide
        # a default version of some lsp (rust-analyzer), but a project might
        # provide it's own version via direnv; neovim will use the latter,
        # project-specific version of the tool.
        paths = with pkgs;
          [
            # Docsets
            dasht
            # C++
            clang-tools
            cmake-format
            cmake-language-server
            cppcheck
            # General
            actionlint
            nodePackages.prettier
            (pkgs.callPackage ./pkgs/languagetool-rs {})
            # Git
            lazygit
            # GraphQL
            nodePackages.graphql-language-service-cli
            # Json
            nodePackages.jsonlint
            nodePackages.vscode-json-languageserver
            # Lua
            luajitPackages.luacheck
            stylua
            # Markdown
            marksman
            # Nix
            alejandra
            nil
            statix
            # Nodejs (e.g. for copilot)
            nodejs
            # Python
            nodePackages.pyright
            yapf
            # Rust
            rust-analyzer
            # Shell
            shellcheck
            shellharden
            shfmt
            # Sourcegraph
            inputs'.sg-nvim.packages.default
            # Typescript
            nodePackages.typescript-language-server
            # Zig
            zls
          ]
          ++ (lib.optionals stdenv.isLinux [
            elinks
            sumneko-lua-language-server
          ]);

        lazy = {
          settings = {
            performance.rtp = {
              reset = true;
              disabled_plugins = [
                "gzip"
                "matchit"
                "matchparen"
                "netrwPlugin"
                "shada"
                "spellfile"
                "tarPlugin"
                "tohtml"
                "zipPlugin"
              ];
            };
          };
          plugins = import ./plugins/spec.nix {
            inherit inputs' pkgs;
            neovim-utils = utils;
          };
          # plugins = import ./plugins {inherit lib pkgs utils;};
          # plugins = neovim-lib.importPluginsFromSpec ./plugins args;
        };
      };
    };
  };
}
