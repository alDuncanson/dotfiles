# Home Manager Repo Guide

## What This Repo Manages

This repository is a macOS Home Manager configuration for multiple profiles on `aarch64-darwin`.

`flake.nix` is the only true entrypoint. It should stay small and mostly declare inputs, systems, and top-level module imports.

`home.nix` is the top-level flake-parts module for this repo. It defines the shared `dotfiles` option namespace, assembles `homeConfigurations`, and imports the rest of the repository tree.

`modules/` contains dendritic feature modules. Each non-entry Nix file under this tree should represent one feature and contribute through the top-level `dotfiles` config rather than acting as an ad hoc standalone expression.

`profiles/` contains profile modules that declare per-machine or per-context identity and package differences layered on top of the shared modules.

## Dendritic Pattern

Follow the dendritic pattern described by `mightyiam/dendritic` for all future structural work in this repo.

In practice for this repository:

- Treat every non-entry Nix file as a flake-parts module, or as a leaf imported by a flake-parts module of the same top-level configuration class.
- Name files by feature, not by expression type. A path should answer "what concern lives here?" rather than "what shape does this file return?"
- Keep `flake.nix` as wiring only. Put reusable values, profile declarations, and lower-level Home Manager or NVF composition under the top-level `dotfiles.*` option tree.
- Prefer contributing to `dotfiles.home.shared` from shared feature modules, and to `dotfiles.profiles.<name>.homeModule` from profile-specific modules.
- Prefer storing shared functions and constants in top-level config such as `dotfiles.lib.*` rather than threading them through `specialArgs` or `extraSpecialArgs`.
- When a config payload is mostly foreign syntax, such as Starship TOML, keep it in an adjacent non-Nix file and load it from the feature module.
- Split files when a feature grows too large, but avoid speculative abstractions. A small feature module is better than a broad catch-all module.
- Prefer automatic or near-automatic importing for feature directories when it keeps the entrypoint small and the tree easy to extend.

Anti-patterns for this repo:

- Reintroducing `extraSpecialArgs` or `specialArgs` just to pass shared values between files.
- Growing `flake.nix` back into the place where outputs, profile data, and feature logic all live together.
- Adding large multi-feature blobs when the concern can live in its own module path.

## Core Commands

Evaluate the config before committing Nix changes:

`nix eval .#homeConfigurations.personal.activationPackage.drvPath`

`nix eval .#homeConfigurations.work.activationPackage.drvPath`

Run the standard formatter:

`nix fmt`

Run the standard flake checks:

`nix flake check`

Build without switching:

`nix run home-manager -- build --flake .#personal`

`nix run home-manager -- build --flake .#work`

Apply the configuration:

`nix run home-manager -- switch --flake .#personal`

`nix run home-manager -- switch --flake .#work`

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

`modules/nvim.nix` is the source of truth for plugin setup, colors, Lua overrides, and the exported `.#neovim` app packaging.

After changing NVF or Neovim behavior, build the Home Manager config and, when useful, smoke-test Neovim headlessly with the flake app.

Example:

`nix run .#neovim -- --headless '+qa!'`

If you need to inspect the pinned NVF source from this flake, resolve its store path with:

`nix eval --impure --raw --expr 'let flake = builtins.getFlake (toString ./.); in flake.inputs.nvf.outPath'`

Then read files under that path to confirm option names or defaults.

When enabling new NVF language modules, prefer checking the pinned NVF module files under `modules/plugins/languages/` rather than guessing option names.

If an NVF change affects the exported `.#neovim` app, test both Home Manager and the standalone flake app. They share the same `dotfiles.lib.mkPkgs` package construction path.

If a Neovim or NVF change pulls in unfree packages, allow them in `dotfiles.lib.mkPkgs`, not only inside Home Manager modules, otherwise `nix run .#neovim` can fail even when Home Manager builds succeed.

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

`nix eval .#homeConfigurations.personal.activationPackage.drvPath`

`nix flake check`

`nix run home-manager -- build --flake .#personal`

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

This repo currently targets multiple macOS profiles on `aarch64-darwin`.

Keep broadly shared packages and settings in dendritic feature modules under `modules/`, and put profile-specific packages or overrides in `profiles/`.

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
