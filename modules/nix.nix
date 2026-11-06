{ config, ... }:
{
  dotfiles.home.modules.nix =
    { lib, pkgs, ... }:
    {
      nix = {
        registry.nixpkgs.flake = config.dotfiles.inputs.nixpkgs;
        nixPath = [ "nixpkgs=flake:nixpkgs" ];
        gc = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          automatic = true;
          dates = "weekly";
        };
      };

      launchd.agents.nix-gc.config.ProgramArguments = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
        lib.mkForce [
          "${pkgs.nix}/bin/nix-collect-garbage"
          "--delete-older-than"
          "14d"
        ]
      );
    };
}
