{ config, ... }:
{
  dotfiles.profiles.personal = {
    aliases = [ "al" ];
    system = config.dotfiles.defaultSystem;
    userName = "al";
    homeDirectory = "/Users/al";
    gitName = "Al Duncanson";
    gitEmail = "alDuncanson@proton.me";
    homeModule =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          asciinema
          fh
          slides
          gotop
          sendme
          harper
          pi-coding-agent
          opencode
          gws
          pandoc
          tectonic
          ngrok
        ];
      };
  };
}
