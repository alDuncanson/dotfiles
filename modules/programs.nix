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
        font-size = 17;
        confirm-close-surface = false;
        quit-after-last-window-closed = true;
        theme = "dark:Gruvbox Dark,light:Gruvbox Light";
      };
    };
    nvf = {
      enable = true;
      settings = import ./nvim.nix {inherit pkgs;};
    };
  };
}
