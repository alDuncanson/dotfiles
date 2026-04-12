{pkgs, ...}: {
  home.packages = with pkgs; [
    asciinema
    fh
    slides
    gotop
    sendme
    harper
    amp-cli
    pi-coding-agent
    opencode
    gws
    pandoc
    tectonic
    ngrok
  ];
}
