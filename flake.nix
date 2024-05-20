{
  inputs = {
    devenv.url = "github:cachix/devenv";
    git-hooks.url = "github:cachix/git-hooks.nix";
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
    neovim-nix = {
      url = "github:willruggiano/neovim.nix";
      inputs.flake-parts.follows = "flake-parts";
    };
    neovim = {
      # https://github.com/nix-community/neovim-nightly-overlay/pull/483
      url = "github:neovim/neovim/nightly";
      flake = false;
    };
    nil.url = "github:oxalica/nil";
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    sg-nvim.url = "github:sourcegraph/sg.nvim";
    vscode-js-debug.url = "github:willruggiano/vscode-js-debug.nix";
    zls.url = "github:zigtools/zls";

    devenv.inputs.pre-commit-hooks.follows = "git-hooks";
  };

  nixConfig = {
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://willruggiano.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "willruggiano.cachix.org-1:rz00ME8/uQfWe+tN3njwK5vc7P8GLWu9qbAjjJbLoSw="
    ];
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
        inputs.hercules-ci-effects.flakeModule
        inputs.neovim-nix.flakeModule
        ./modules
      ];

      systems = ["aarch64-darwin" "x86_64-linux"];
      perSystem = {
        config,
        lib,
        pkgs,
        inputs',
        ...
      }: {
        _module.args.nix-colors =
          inputs.nix-colors.lib
          // {
            contrib = inputs.nix-colors.lib-contrib {inherit pkgs;};
            schemes = inputs.nix-colors.colorSchemes;
          };

        apps = {
          push.program = pkgs.writeShellApplication {
            name = "push.sh";
            runtimeInputs = with pkgs; [cachix jq];
            text = ''
              nix flake archive --json \
              | jq -r '.path,(.inputs|to_entries[].value.path)' \
              | cachix push willruggiano;

              nix build --json \
              | jq -r '.[].outputs | to_entries[].value' \
              | cachix push willruggiano;

              cachix pin willruggiano nvim-drv "$(nix build --print-out-paths)"
            '';
          };
          update.program = pkgs.writeShellApplication {
            name = "update.sh";
            runtimeInputs = with pkgs; [niv];
            text = ''
              nix flake update &&
              niv update &&
              nix run .#nvim-treesitter.update-grammars &&
              nix flake check --impure &&
              git commit -am 'chore: 🌶️🌶️🌶️' &&
              git push
            '';
          };
        };

        devenv.shells.default = {
          name = "neovim";
          # https://github.com/cachix/devenv/issues/528
          containers = lib.mkForce {};
          packages = with pkgs; [alejandra just niv nodejs tree-sitter];
          pre-commit.hooks = {
            alejandra.enable = true;
            stylua.enable = true;
          };
          scripts = {
            plug-add.exec = ''
              niv add git git@github.com:$1 && git add -A && git commit -am "feat(plug): $1"
            '';
          };
        };

        formatter = pkgs.alejandra;

        packages = {
          default = pkgs.symlinkJoin {
            name = "nvim-bin";
            paths = [
              config.neovim.final # `nvim`
              (pkgs.writeShellScriptBin "fvim" ''
                nvim +'Telescope smart_open'
              '')
            ];
            meta.mainProgram = "nvim";
          };
          luafun = pkgs.luajit.pkgs.callPackage ./pkgs/luafun.nix {};
          neovim-nightly = pkgs.callPackage ./pkgs/neovim {inherit inputs;};
          nvim = config.neovim.final;
          nvim-dbee = pkgs.callPackage ./pkgs/nvim-dbee.nix {};
          nvim-treesitter = pkgs.callPackage ./pkgs/nvim-treesitter {};
        };
      };

      hercules-ci.flake-update = {
        enable = true;
        baseMerge.enable = true;
        baseMerge.method = "rebase";
        autoMergeMethod = "rebase";
        when = {
          dayOfWeek = ["Mon"];
          hour = [0];
        };
      };
    };
}
