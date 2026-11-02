{ ... }:
{
  dotfiles.home.modules.dev =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          lua
          go
          biome
          nodejs
          bun
          rustup
          gh
          python3
          awscli2
          vscode-langservers-extracted
          uv
          ruff
          ty
          kubectl
          kubernetes-helm
          docker
          opentofu
          act
        ];

        sessionPath = [
          "$HOME/.npm-global/bin"
          "$HOME/go/bin"
        ];

        sessionVariables.NPM_CONFIG_PREFIX = "$HOME/.npm-global";
      };
    };
}
