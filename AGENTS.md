# Dotfiles

Agent guide. Declarative macOS user environments in Nix, applied with Home
Manager.

- `flake.nix`: inputs, imports and exports the `dotfiles` flake module, declares the `personal` profile
- `dotfiles.nix`: the flake module. A function of this flake's inputs; defines `dotfiles.*`, imports `modules/`, turns `dotfiles.profiles` into `homeConfigurations`, and exports `homeModules.default`
- `modules/`: dendritic feature modules, one concern per file. Each contributes Home Manager config through `dotfiles.home.shared`; `nvim.nix` also contributes flake outputs through `perSystem`
- `personal.nix`: the personal profile's Home Manager module
- Other machines declare their profile in their own flake with `dotfiles` as the only input; see `README.md`

## Commands

- `nix fmt` and `nix flake check`
- `nix run home-manager -- build --flake .#personal`, then `switch`
- `nix run .#neovim -- --headless '+qa!'` after any Neovim change
- `nix flake update`, then build, `nix flake check`, and the Neovim smoke test before committing
- Refactor check: `nix build --no-link --print-out-paths .#homeConfigurations.personal.activationPackage` before and after; the same path means nothing changed

## Rules

- Nix files hold code only. Rationale goes in commit messages or here.
- Every file under `modules/` is a flake-parts module. Read inputs through `config.dotfiles.inputs`, never the `inputs` argument, which belongs to whichever flake is importing. Shared values go in `dotfiles.lib.*`, not `specialArgs`.
- Name files by concern. Config in a foreign syntax, like the Starship TOML, stays in an adjacent file loaded by its module.
- `flake.nix` stays wiring only.
- Conventional commits: `feat(nvim): ...`, `fix(programs): ...`, `docs(agents): ...`.
- Public repo: no secrets and nothing employer-specific. That lives in the private work flake.

## Neovim

`modules/nvim.nix` holds the nvf settings and the exported `.#neovim` package.
Both build through `dotfiles.lib.mkPkgs`, so unfree packages are allowed there,
not in a module. To check an nvf option against the pinned source:

```bash
nix eval --impure --raw --expr 'let flake = builtins.getFlake (toString ./.); in flake.inputs.nvf.outPath'
```
