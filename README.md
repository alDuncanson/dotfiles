# dotfiles

macOS Home Manager dotfiles for `aarch64-darwin`, shared across personal and work profiles.

- Home Manager for user environment management
- `flake-parts` as the top-level flake composition layer
- `nvf` for Neovim configuration and standalone `.#neovim`
- Ghostty, Zsh, Gruvbox, MonoLisa

## Layout

- `flake.nix`: entrypoint only; declares inputs and imports the top-level module
- `home.nix`: top-level flake-parts module; defines `dotfiles.*`, assembles profiles, exports `homeConfigurations`
- `modules/`: shared dendritic feature modules; each file contributes one concern
- `profiles/`: profile declarations and per-profile Home Manager deltas

## Profiles

- `personal` with alias `al`
- `work` with alias `sn93ib`

`home-manager switch --flake .` resolves via the alias on each machine. Explicit forms like `.#personal` and `.#work` remain available.

## Commands

```bash
# format all Nix files via the flake formatter
nix fmt

# run the standard repo checks
nix flake check

# inspect exports
nix flake show --all-systems

# evaluate profiles
nix eval .#homeConfigurations.personal.activationPackage.drvPath
nix eval .#homeConfigurations.work.activationPackage.drvPath

# build profiles without switching
nix run home-manager -- build --flake .#personal
nix run home-manager -- build --flake .#work

# apply the current machine profile or an explicit profile
nix run home-manager -- switch --flake .
nix run home-manager -- switch --flake .#work

# run the exported Neovim app
nix run .#neovim
nix run .#neovim -- --headless '+qa!'
```

## Bootstrap

```bash
nix shell nixpkgs#git -c git clone <repo-url> ~/.config/home-manager
cd ~/.config/home-manager
nix run home-manager -- switch --flake .
```

After bootstrap, updates are just `git pull` and `nix run home-manager -- switch --flake .`.
