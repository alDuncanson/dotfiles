{ ... }:
{
  dotfiles.home.shared = {
    programs.lazygit = {
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
  };
}
