# Dotfiles

Declarative dotfiles and user environment configuration for my MacOS machines,
written in Nix.

One flake defines everything a machine needs as a user: packages, shell, git,
SSH, Neovim, fonts, terminal. Applying it rebuilds that environment from these
files, so every machine matches and every change is a commit.

## Profiles

- `personal` with alias `al`

`nix run home-manager -- switch --flake .` resolves via the alias on each
machine. The explicit form `.#personal` remains available.

A profile that does not belong in a public repository lives in its own flake.
The flake module closes over this flake's inputs, so that flake needs only:

```nix
{
  inputs.dotfiles.url = "github:alDuncanson/dotfiles";

  outputs =
    inputs@{ dotfiles, ... }:
    dotfiles.inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ dotfiles.flakeModules.default ];
      dotfiles.profiles.work = {
        aliases = [ "<login>" ];
        userName = "<login>";
        homeModule = ./home.nix;
      };
    };
}
```

Hosts that compose the user environment themselves, such as a NixOS system, can
import the shared configuration as a plain module from `homeModules.default`
instead.

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

After bootstrap, updates are just `git pull` and
`nix run home-manager -- switch --flake .`.
