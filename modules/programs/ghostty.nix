{ ... }:
{
  dotfiles.home.modules.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
        settings = {
          font-family = "MonoLisaCode";
          font-size = 17;
          confirm-close-surface = false;
          mouse-hide-while-typing = true;
          quit-after-last-window-closed = true;
          theme = "dark:Gruvbox Dark,light:Gruvbox Light";
        };
      };
    };
}
