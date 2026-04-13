{ ... }:
{
  dotfiles.home.shared =
    { pkgs, ... }:
    {
      programs.zsh = {
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
    };
}
