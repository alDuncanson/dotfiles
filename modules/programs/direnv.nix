{ ... }:
{
  dotfiles.home.shared =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
        package = pkgs.direnv;
        nix-direnv.enable = true;
        config.global.hide_env_diff = true;
      };
    };
}
