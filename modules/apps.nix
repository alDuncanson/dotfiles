{ ... }:
{
  dotfiles.home.modules.apps =
    { lib, pkgs, ... }:
    {
      targets.darwin = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        copyApps.enable = true;
        linkApps.enable = false;
      };
    };
}
