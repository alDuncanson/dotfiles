# dotfiles

This repository contains my [Nix flake](https://wiki.nixos.org/wiki/Flakes)
managed dotfiles and user environment.

- Terminal emulator: [Ghostty](https://ghostty.org/)
- Text editor: [Neovim](https://neovim.io/)
- Neovim configuration framework: [nvf](https://github.com/NotAShelf/nvf)
- Theme: [Gruvbox](https://github.com/morhetz/gruvbox)
- User environment configuration:
  [Home Manager](https://github.com/nix-community/home-manager)
- Shell: [Zsh](https://www.zsh.org/)
- Font: [MonoLisa](https://www.monolisa.dev/)

The same Neovim config is also exposed as a standalone flake app, so you can
run it directly with `nix run .` or from a remote machine with
`nix run github:alDuncanson/dotfiles`.
