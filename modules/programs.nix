{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    bat = {
      enable = true;
      config.theme = "gruvbox-dark";
    };
    starship = {
      enable = true;
      settings = {
        gcloud.disabled = true;
      };
    };
    direnv = {
      enable = true;
      # Work around direnv 2.37.1 build regression on darwin after flake update.
      package = pkgs.direnv.overrideAttrs (old: {
        env =
          (old.env or {})
          // {
            CGO_ENABLED = "1";
          };
      });
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
    nvf = {
      enable = true;
      settings = import ./nvim.nix;
    };
  };
}
