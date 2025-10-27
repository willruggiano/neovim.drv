install:
  nix profile upgrade path:$(pwd)#packages.x86_64-linux.default
  notify-send --transient 'neovim be ready'

build:
  nom build

push:
  nix flake check
  nix flake archive --json | jq -r '.path,(.inputs|to_entries[].value.path)' | cachix push willruggiano
  nix build --json | jq -r '.[].outputs | to_entries[].value' | cachix push willruggiano
  cachix pin willruggiano nvim-drv "$(nix build --print-out-paths)"

run:
  nix run

update:
  nix flake update
  niv update
  # nix-update --flake nvim-dbee --version=branch --subpackage dbee
  # nix-update --flake sqruff --version-regex='v(.*)' --override-filename pkgs/sqruff.nix
  nix flake check
