{ ... }:
{
  dotfiles.home.modules.lazygit =
    { pkgs, ... }:
    {
      programs.lazygit = {
        enable = true;
        enableZshIntegration = true;
        settings.os = {
          editPreset = "nvim-remote";
          open = ''
            if [ -z "$NVIM" ]; then
              ${if pkgs.stdenv.hostPlatform.isDarwin then "open" else "xdg-open"} -- {{filename}}
            else
              nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-tab {{filename}}
            fi
          '';
        };
      };
    };
}
