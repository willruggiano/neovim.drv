install:
  nix profile upgrade git+file://$(pwd)#packages.x86_64-linux.default
  notify-send --transient 'neovim be ready'

build:
  nom build

run:
  nix run
