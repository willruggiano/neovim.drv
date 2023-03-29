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
        paths = with pkgs; [
          # Docsets
          dasht
          (lib.optionals stdenv.isLinux elinks)
          # C++
          clang-tools
          cmake-language-server
          cppcheck
          # Git
          lazygit
          # GraphQL
          nodePackages.graphql-language-service-cli
          # Json
          nodePackages.jsonlint
          # Lua
          luajitPackages.luacheck
          (lib.optionals stdenv.isLinux sumneko-lua-language-server)
          # Markdown
          marksman
          # Nix
          nil
          # Nodejs (e.g. for copilot)
          nodejs
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
    };
  };
}
