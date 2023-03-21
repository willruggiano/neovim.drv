# neovim.drv

This is my personal Neovim environment, packaged as a Nix flake.
It uses [neovim.nix] under the hood.

## Try it out

```sh
nix run github:willruggiano/neovim.drv
```

## What's in the box?

```
nix/         # contains niv sources for various packages
pkgs/        # contains custom nix derivations for a few packages
plugins/     # where all of the lua code is for various plugins
  bombadil/  # my personal "plugin", with my colorscheme, keymaps, options, et al
```

[neovim.nix]: https://github.com/willruggiano/neovim.nix
