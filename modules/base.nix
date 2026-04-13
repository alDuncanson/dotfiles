{...}: {
  dotfiles.home.shared = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        # Shared CLI and development tools used on both personal and work machines.
        htop
        eza
        fd
        git
        wget
        hyperfine
        tree
        lua
        go
        fastfetch
        ripgrep
        yazi
        glow
        amp-cli
        biome
        nodejs
        bun
        rustup
        gh
        jq
        yq
        just

        # Shared Python, cloud, container, and infrastructure tooling.
        python3
        awscli2
        vscode-langservers-extracted
        uv
        ruff
        ty
        google-cloud-sdk
        kubectl
        kubernetes-helm
        docker
        podman
        podman-compose
        terraform
        act
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
  };
}
