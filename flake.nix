{
  description = "dotfiles";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:denful/import-tree";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    react-hooks-snippets = {
      url = "github:alDuncanson/react-hooks-snippets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      dotfiles = import ./dotfiles.nix inputs;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ dotfiles ];
      flake.flakeModules.default = dotfiles;

      dotfiles.profiles.personal = {
        aliases = [ "al" ];
        userName = "al";
        homeModule = ./personal.nix;
      };
    };
}
