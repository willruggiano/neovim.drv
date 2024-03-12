alias b := build
alias i := install
alias r := run

build:
  nom build --accept-flake-config

install: build
  nix profile update --accept-flake-config --impure 0
  notify-send --transient 'neovim be ready'

run:
  nix run --accept-flake-config

default: build
