{ ... }:
{
  dotfiles.home.shared = {
    programs.opencode = {
      enable = true;
      settings.autoUpdate = true;
    };
  };
}