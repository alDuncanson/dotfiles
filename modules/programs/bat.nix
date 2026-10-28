{ ... }:
{
  dotfiles.home.modules.bat = {
    programs.bat = {
      enable = true;
      config = {
        theme = "auto:system";
        theme-dark = "gruvbox-dark";
        theme-light = "gruvbox-light";
      };
    };
  };
}
