{pkgs, ...}: {
  imports = [
    ./programs/starship.nix
  ];

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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        aliases.co = "pr checkout";
        git_protocol = "https";
        prompt = "enabled";
      };
    };
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        file-style = "yellow";
        file-decoration-style = "yellow ul";
        hunk-header-style = "blue";
        hunk-header-decoration-style = "blue box";
        minus-style = "red";
        minus-emph-style = "red bold";
        minus-non-emph-style = "red";
        minus-empty-line-marker-style = "red";
        zero-style = "normal";
        plus-style = "green";
        plus-emph-style = "green bold";
        plus-non-emph-style = "green";
        plus-empty-line-marker-style = "green";
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        vivid_theme="gruvbox-light"
        if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
          vivid_theme="gruvbox-dark"
        fi

        export BAT_THEME="$vivid_theme"
        export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate "$vivid_theme")"
      '';
      shellAliases = {
        ga = "git add";
        gb = "git branch";
        gc = "git commit";
        gd = "git diff";
        gl = "git log --graph --decorate --oneline";
        gs = "git status";
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
      settings = {
        commit.gpgsign = false;
        diff.submodule = "log";
        fetch.prune = true;
        init.defaultBranch = "main";
      };
    };
    lazygit = {
      enable = true;
      enableZshIntegration = true;
      settings.os = {
        editPreset = "nvim-remote";
        open = ''
          if [ -z "$NVIM" ]; then
            open -- {{filename}}
          else
            nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-tab {{filename}}
          fi
        '';
      };
    };
    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        font-family = "MonoLisa Custom";
        font-size = 17;
        confirm-close-surface = false;
        mouse-hide-while-typing = true;
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
