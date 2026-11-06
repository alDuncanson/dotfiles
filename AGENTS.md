# Dotfiles

Agent guide. Declarative user environments for macOS and Linux, applied with
Home Manager, and NixOS hosts.

- `flake.nix`: inputs, imports and exports the `dotfiles` flake module, declares the `personal` profile, imports `hosts/`
- `dotfiles.nix`: the flake module. A function of this flake's inputs; defines `dotfiles.*`, imports `modules/`, turns `dotfiles.profiles` into `homeConfigurations`, and exports `homeModules` and `nixosModules`
- `modules/`: dendritic feature modules, one concern per file. Each contributes Home Manager config through `dotfiles.home.modules.<name>`, which profiles opt into by name, or NixOS config through `dotfiles.nixos.modules.<name>`, which hosts opt into; `nvim.nix` also contributes flake outputs through `perSystem`
- `hosts/<host>/default.nix`: a flake-parts module declaring the host's profile and exporting `nixosConfigurations.<host>`, next to its generated `hardware-configuration.nix` and the profile's `home.nix`. Hosts stay out of `modules/` so flakes importing `flakeModules.default` do not inherit them
- `personal.nix`: the personal profile's Home Manager module
- Other machines declare their profile in their own flake with `dotfiles` as the only input; see `README.md`

## Profiles and hosts

- A profile is one user environment: `system`, `userName`, `modules` (names from `dotfiles.home.modules`, all of them by default), `homeModule`, and `stateVersion`. `dotfiles.nix` builds `homeConfigurations.<name>` from it, plus one per alias
- `profiles.<name>.homeModules` is the read-only list that build consumes. A NixOS host imports the same list into `home-manager.users.<user>`, so the standalone and NixOS builds of a profile cannot drift; `hosts/thinkpad` is the pattern
- `dotfiles.nixpkgs.config` and `dotfiles.nixpkgs.overlays` feed every nixpkgs instance: `perSystem`, every profile, and hosts that set `nixpkgs.config` and `nixpkgs.overlays` from them. A flake importing the module patches a package there, not with `lib.hiPrio`
- Profiles take every home module by default, so platform-specific config does not belong in `dotfiles.home.modules`. A desktop session is a `dotfiles.nixos.modules` entry plus the host's `home.nix`
- `cli` holds shell tools every machine wants; `dev` holds language toolchains. Tools only one machine needs live in that machine's flake
- `nix` pins the `nixpkgs` registry entry and `NIX_PATH` to the locked nixpkgs, so `nix shell nixpkgs#x` and `nix-shell -p x` reuse the store paths the profile already has instead of fetching whatever the global registry points at. On darwin it also collects garbage weekly, dropping generations older than 14 days, because nothing else does there; NixOS hosts collect at the system level. The collector's arguments are forced on the launchd agent rather than set through `nix.gc.options`, because Home Manager hands that string to `nix-collect-garbage` as a single argument on darwin and the collector rejects it
- `apps` copies macOS app bundles into `~/Applications/Home Manager Apps` instead of symlinking them, so Launch Services tags the copy rather than the store path. A tagged store path cannot be deleted by the daemon, which aborts garbage collection on it. The first switch after enabling asks for the App Management permission for the terminal; copies are also visible to Spotlight

## Commands

- `nix fmt` and `nix flake check`
- `nix run home-manager -- build --flake .#personal`, then `switch`
- `nixos-rebuild build --flake .#thinkpad`, then `sudo nixos-rebuild switch --flake .#thinkpad` on that machine
- `nix run .#neovim -- --headless '+qa!'` after any Neovim change
- `nix flake update`, then build, `nix flake check`, and the Neovim smoke test before committing
- Refactor check: `nix build --no-link --print-out-paths .#homeConfigurations.personal.activationPackage` before and after; the same path means nothing changed. From another platform, compare `nix eval --raw` of its `drvPath` instead. Do the same for `.#nixosConfigurations.thinkpad.config.system.build.toplevel`. Moving a package between modules reorders `home.packages` and changes the path without changing the contents; compare `nix eval --json .#homeConfigurations.personal.config.home.packages --apply 'map (p: p.name)'` for that
- Platform-specific settings use `pkgs.stdenv.hostPlatform.isDarwin`, written so the other platform's output does not change

## Rules

- Nix files hold code only. Rationale goes in commit messages or here.
- Every file under `modules/` is a flake-parts module. Read inputs through `config.dotfiles.inputs`, never the `inputs` argument, which belongs to whichever flake is importing. Shared values go in `dotfiles.lib.*`, not `specialArgs`. The one deliberate exception is `self` in `quality.nix`: the formatting check must cover whoever imports the module.
- Name files by concern. Config in a foreign syntax, like the Starship TOML, stays in an adjacent file loaded by its module.
- `flake.nix` stays wiring only.
- Conventional commits: `feat(nvim): ...`, `fix(programs): ...`, `docs(agents): ...`.
- Public repo: no secrets and nothing employer-specific. That lives in the private work flake.
- `main` is append-only. Other flakes lock it by commit, and a rewrite orphans their locks.

## Neovim

`modules/nvim.nix` holds the nvf settings and the exported `.#neovim` package.
Both build through `dotfiles.lib.mkPkgs`, so unfree packages are allowed there,
not in a module. blink-cmp comes from nixpkgs through `vim.pluginOverrides`: nvf's own
package compiles its Rust matcher on every machine, and nixpkgs ships the same
version prebuilt. To check an nvf option against the pinned source:

```bash
nix eval --impure --raw --expr 'let flake = builtins.getFlake (toString ./.); in flake.inputs.nvf.outPath'
```
