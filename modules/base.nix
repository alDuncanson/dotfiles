{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      htop
      eza
      fd
      git
      wget
      hyperfine
      tree
      asciinema
      lua
      go
      fh
      slides
      gotop
      fastfetch
      ripgrep
      yazi
      glow
      sendme
      biome
      harper
      nodejs
      awscli2
      vscode-langservers-extracted
      uv
      google-cloud-sdk
      gws
      docker
      gh
      terraform
      bun
      rustup
      act
      pandoc
      tectonic
      just
      ngrok
    ];

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
    ];

    sessionVariables = {
      EDITOR = "nvim";
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    shell.enableZshIntegration = true;
  };
}
