{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "auto:system";
        theme-dark = "gruvbox-dark";
        theme-light = "gruvbox-light";
      };
    };
    starship = {
      enable = true;
      settings = {
        gcloud.disabled = true;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        find = "fd";
        cat = "bat";
        ls = "eza --icons=always";
        lsl = "ls -l";
        lsls = "lsl --total-size";
        bench = "hyperfine";
      };
    };
    zellij = {
      enable = true;
      enableZshIntegration = true;
    };
    git = {
      enable = true;
      signing.format = null;
      settings.user = {
        name = "alDuncanson";
        email = "alDuncanson@proton.me";
      };
    };
    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        font-family = "MonoLisa Custom";
        font-size = 15;
        confirm-close-surface = false;
        macos-titlebar-style = "hidden";
        quit-after-last-window-closed = true;
        theme = "dark:Gruvbox Dark,light:Gruvbox Light";
      };
    };
    nvf = {
      enable = true;
      settings = import ./nvim.nix;
    };
  };

  home.file.".local/bin/zellij" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
        config="$HOME/.config/zellij/config-dark.kdl"
      else
        config="$HOME/.config/zellij/config-light.kdl"
      fi

      exec ${pkgs.zellij}/bin/zellij --config "$config" "$@"
    '';
  };

  xdg.configFile."zellij/config-dark.kdl".text = ''
    theme "gruvbox-dark"
    show_startup_tips false
  '';

  xdg.configFile."zellij/config-light.kdl".text = ''
    theme "gruvbox-light"
    show_startup_tips false
  '';
}
