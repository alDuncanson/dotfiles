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
      ruff
      ty
      google-cloud-sdk
      kubectl
      gws
      docker
      podman
      podman-compose
      gh
      glab
      terraform
      jq
      yq
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
