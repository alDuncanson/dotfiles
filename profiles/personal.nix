{pkgs, ...}: {
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
}
