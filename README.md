# dotfiles

This repository contains my [Nix flake](https://wiki.nixos.org/wiki/Flakes)
managed dotfiles and user environment for both personal and work macOS
machines on Apple Silicon.

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

## Profiles

The flake currently exposes these Home Manager profiles:

- `personal`
- `work`

`al` and `sn93ib` are kept as per-user aliases, so `home-manager switch --flake .`
resolves automatically on the personal and work machines.

## Bootstrap A New Work Machine

If the machine already has Nix installed, you do not need to install Home
Manager separately. Clone this repo and run the work profile through
`nix run`.

If `git` is not installed yet, clone with a temporary Nix shell:

```bash
nix shell nixpkgs#git -c git clone <repo-url> ~/.config/home-manager
```

If `git` is already available:

```bash
mkdir -p ~/.config
git clone <repo-url> ~/.config/home-manager
```

Then apply the work profile:

```bash
cd ~/.config/home-manager
nix run home-manager -- switch --flake .
```

`nix run home-manager -- switch --flake .#work` works too if you want to be explicit.

After the first bootstrap, updates are just:

```bash
cd ~/.config/home-manager
git pull
nix run home-manager -- switch --flake .
```
