{ ... }:
{
  dotfiles.home.modules.starship = {
    programs.starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
  };
}
