{ ... }:
{
  dotfiles.home.shared =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
        package =
          if pkgs.stdenv.hostPlatform.isDarwin then
            pkgs.direnv.overrideAttrs {
              doCheck = false;
            }
          else
            pkgs.direnv;
        nix-direnv.enable = true;
        config.global.hide_env_diff = true;
      };
    };
}
