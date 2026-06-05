install:
  nix profile upgrade nvim
  notify-send --transient 'neovim be ready'

no-builders:
  nix profile upgrade nvim --builders ""
  notify-send --transient 'neovim be ready'

build:
  nom build

push:
  nix flake check
  nix flake archive --json | jq -r '.path,(.inputs|to_entries[].value.path)' | cachix push willruggiano
  nix build --json | jq -r '.[].outputs | to_entries[].value' | cachix push willruggiano
  # cachix pin willruggiano nvim-drv "$(nix build --print-out-paths)"

run:
  nix run

update:
  nix flake update
  niv update
  nix flake check
