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

## Neovim And NVF

Keep Neovim changes declarative under `programs.nvf.settings`.

`modules/nvim.nix` is the source of truth for plugin setup, colors, and Lua overrides.

After changing NVF or Neovim behavior, build the Home Manager config and, when useful, smoke-test Neovim headlessly with the flake app.

Example:

`nix run .#neovim -- --headless '+qa!'`

## Maintenance

Update inputs with:

`nix flake update`

List generations with:

`nix run home-manager -- generations`

Expire old generations with:

`nix run home-manager -- expire-generations "-14 days"`

Collect garbage with:

`nix-collect-garbage -d`

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
