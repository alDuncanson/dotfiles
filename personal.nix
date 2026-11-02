{ pkgs, ... }:
{
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
