install:
  nix profile upgrade --accept-flake-config --impure 0
  notify-send --transient 'neovim be ready'

build:
  nom build --accept-flake-config

run:
  nix run --accept-flake-config
