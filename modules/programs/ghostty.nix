{ ... }:
{
  dotfiles.home.shared =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty-bin;
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
