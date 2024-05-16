install:
  nix profile upgrade 0
  notify-send --transient 'neovim be ready'

build:
  nom build

run:
  nix run
