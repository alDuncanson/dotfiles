# Home Manager Repo Guide

## What This Repo Manages

This repository is a single-user macOS Home Manager configuration for `al` on `aarch64-darwin`.

`home.nix` is the top-level Home Manager module.

`flake.nix` defines the flake inputs, `homeConfigurations.al`, and the exported Neovim package/app.

`modules/` contains the actual Home Manager and NVF configuration split by concern.

## Core Commands

Evaluate the config before committing Nix changes:

`nix eval .#homeConfigurations.al.activationPackage.drvPath`

Build without switching:

`nix run home-manager -- build --flake .#al`

Apply the configuration:

`nix run home-manager -- switch --flake .#al`

Inspect exported flake outputs when changing `flake.nix`:

`nix flake show --all-systems`

Run the exported Neovim app directly:

`nix run .#neovim`

Check which packages and apps the flake currently exports:

`nix flake show --all-systems`

Search nixpkgs for candidate package names during discovery:

`nix search nixpkgs <name>`

When validating a package for this repo, prefer the pinned flake package set over bare `nixpkgs` search results.

## Neovim And NVF

Keep Neovim changes declarative under `programs.nvf.settings`.

`modules/nvim.nix` is the source of truth for plugin setup, colors, and Lua overrides.

After changing NVF or Neovim behavior, build the Home Manager config and, when useful, smoke-test Neovim headlessly with the flake app.

Example:

`nix run .#neovim -- --headless '+qa!'`

If you need to inspect the pinned NVF source from this flake, resolve its store path with:

`nix eval --impure --raw --expr 'let flake = builtins.getFlake (toString ./.); in flake.inputs.nvf.outPath'`

Then read files under that path to confirm option names or defaults.

When enabling new NVF language modules, prefer checking the pinned NVF module files under `modules/plugins/languages/` rather than guessing option names.

If an NVF change affects the exported `.#neovim` app, test both Home Manager and the standalone flake app. They share the top-level `pkgs` set from `flake.nix`.

If a Neovim or NVF change pulls in unfree packages, allow them in the shared `pkgs` import in `flake.nix`, not only inside Home Manager modules, otherwise `nix run .#neovim` can fail even when Home Manager builds succeed.

Useful headless smoke-test patterns:

`nix run .#neovim -- --headless '+qa!'`

`nix run .#neovim -- --headless '+lua print(require("yazi").config.yazi_floating_window_border)' '+qa!'`

## Maintenance

Update inputs with:

`nix flake update`

List generations with:

`nix run home-manager -- generations`

Expire old generations with:

`nix run home-manager -- expire-generations "-14 days"`

Collect garbage with:

`nix-collect-garbage -d`

After updating inputs, rerun config evaluation, Home Manager build, and a Neovim smoke test before committing.

`nix eval .#homeConfigurations.al.activationPackage.drvPath`

`nix run home-manager -- build --flake .#al`

`nix run .#neovim -- --headless '+qa!'`

## Debugging And Inspection

To inspect effective generated program config after a switch, read the files under `~/.config`, for example:

`cat ~/.config/bat/config`

This is useful for confirming that Home Manager rendered the expected flags.

To compare current PATH installations before replacing a manually installed CLI, use:

`which -a <command>`

To find likely non-Nix installs that may need cleanup after a migration, use:

`find "$HOME/.local/bin" /opt/homebrew/bin /usr/local/bin -maxdepth 1 -name '<command>' 2>/dev/null`

When removing old manual installs, preserve config and state directories unless the task explicitly asks to remove them too.

This repo currently targets one user and one system only: `al` on `aarch64-darwin`.

## Commit Format

Use conventional commits that match the existing history.

Preferred format:

`type(scope): short summary`

Examples from this repo's style:

`feat(nvim): flatten popup surfaces`

`fix(programs): drop stale direnv override`

`refactor(dotfiles): split home config into modules`

`docs(agents): rewrite repository guide`

Keep summaries imperative and concise.

## Working Style

Prefer minimal, targeted edits.

Do not add wrapper scripts for standard Nix or Home Manager operations.

When changing Nix files, run at least config evaluation before committing, and usually run a build as well.
