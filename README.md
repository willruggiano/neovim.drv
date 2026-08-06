# neovim.drv

This is my personal Neovim environment, packaged as a Nix flake.
It uses [neovim.nix] under the hood.

## Try it out

```bash
nix run github:willruggiano/neovim.drv
```

## What's in the box?

```
plugins/     # where all the lua code is for various plugins
  bombadil/  # my personal "plugin", with my colorscheme, keymaps, options, et al
```

[neovim.nix]: https://github.com/willruggiano/neovim.nix
