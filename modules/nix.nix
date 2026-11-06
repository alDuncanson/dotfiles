{ config, ... }:
{
  dotfiles.home.modules.nix = {
    nix = {
      registry.nixpkgs.flake = config.dotfiles.inputs.nixpkgs;
      nixPath = [ "nixpkgs=flake:nixpkgs" ];
    };
  };
}
