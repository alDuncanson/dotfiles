{ ... }:
{
  dotfiles.home.modules.cli =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          htop
          eza
          fd
          git
          wget
          hyperfine
          tree
          fastfetch
          ripgrep
          yazi
          glow
          jq
          yq
          just
          herdr
        ];

        sessionPath = [ "$HOME/.local/bin" ];

        sessionVariables.EDITOR = "nvim";
      };
    };
}
