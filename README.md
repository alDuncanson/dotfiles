# dotfiles

macOS Home Manager dotfiles for `aarch64-darwin`.

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

`home-manager switch --flake .` resolves via the alias on each machine. The explicit form `.#personal` remains available.

Machine-specific profiles that do not belong in a public repository live in their own flake, which imports this one as a module:

```nix
inputs.dotfiles.url = "github:alDuncanson/dotfiles";

imports = [ inputs.dotfiles.flakeModules.default ./profiles/<name>.nix ];
```

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

# build profiles without switching
nix run home-manager -- build --flake .#personal

# apply the current machine profile
nix run home-manager -- switch --flake .

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
