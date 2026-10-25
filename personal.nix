{ pkgs, ... }:
{
  programs.git.settings.user.email = "alDuncanson@proton.me";

  home.packages = with pkgs; [
    asciinema
    fh
    slides
    sendme
    harper
    gws
    pandoc
    tectonic
    ngrok
  ];
}
